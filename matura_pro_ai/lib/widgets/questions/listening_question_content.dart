import 'dart:async';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

import '../../core/constants.dart';
import '../../core/theme_defaults.dart';

import '../../models/questions/question_type.dart';
import '../../controllers/questions/listening_question_controller.dart';
import '../../controllers/questions/question_controller.dart';
import '../../controllers/questions/multiple_choice_question_controller.dart';
import '../../controllers/questions/text_input_question_controller.dart';
import '../../controllers/questions/category_question_controller.dart';
import '../../controllers/questions/missing_word_question_controller.dart';

import 'multiple_choice_question_content.dart';
import 'text_input_question_content.dart';
import 'category_question_content.dart';
import 'missing_word_question_content.dart';

class ListeningQuestionContent extends StatefulWidget {
  final ListeningQuestionController controller;

  const ListeningQuestionContent({super.key, required this.controller});

  @override
  State<ListeningQuestionContent> createState() =>
      _ListeningQuestionContentState();
}

class _ListeningQuestionContentState extends State<ListeningQuestionContent> {
  final AudioPlayer _player = AudioPlayer();
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;
  bool _isLoaded = false;
  bool _isPlaying = false;

  StreamSubscription? _positionSub;
  StreamSubscription? _durationSub;
  StreamSubscription? _stateSub;
  StreamSubscription? _completeSub;

  @override
  void initState() {
    super.initState();

    _positionSub = _player.onPositionChanged.listen((pos) {
      setState(() {
        _position = pos;
      });
    });

    _durationSub = _player.onDurationChanged.listen((dur) {
      setState(() {
        _duration = dur;
      });
    });

    _stateSub = _player.onPlayerStateChanged.listen((state) {
      setState(() {
        _isPlaying = state == PlayerState.playing;
      });
    });

    _completeSub = _player.onPlayerComplete.listen((_) {
      setState(() {
        _position = Duration.zero;
        _isPlaying = false;
        _isLoaded = false;
      });
    });
  }

  @override
  void dispose() {
    _player.stop();
    _positionSub?.cancel();
    _durationSub?.cancel();
    _stateSub?.cancel();
    _completeSub?.cancel();
    _player.dispose();
    super.dispose();
  }

  Future<void> _playAudio() async {
    if(_isLoaded)
    {
      return await _player.resume();
    }
    await _player
        .play(AssetSource('audio/${widget.controller.question.audioPath}'));
    
    setState(() {_isLoaded = true;});
  }

  Future<void> _pauseAudio() async {
    await _player.pause();
  }

  Widget _buildSubQuestion(int index, QuestionController subController) {
    switch (subController.type) {
      case QuestionType.multipleChoice:
        return MultipleChoiceQuestionContent(
          controller: subController as MultipleChoiceQuestionController,
        );
      case QuestionType.category:
        return CategoryQuestionContent(
          controller: subController as CategoryQuestionController,
        );
      case QuestionType.textInput:
        return TextInputQuestionContent(
          controller: subController as TextInputQuestionController,
        );
      case QuestionType.missingWord:
        return MissingWordQuestionContent(
          controller: subController as MissingWordQuestionController,
        );
      default:
        return const SizedBox.shrink();
    }
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  Widget _buildActionButton()
  {
    if(!_isLoaded || _position == Duration.zero)
    {
      return ElevatedButton.icon(
        onPressed: _playAudio,
        icon: const Icon(Icons.play_arrow),
        label: const Text(AppStrings.playAudio),
      );
    }

    if(_isPlaying)
    {
      return ElevatedButton.icon(
        onPressed: _pauseAudio,
        icon: const Icon(Icons.pause),
        label: const Text(AppStrings.pauseAudio),
      );
    }
    else 
    {
      return ElevatedButton.icon(
        onPressed: _playAudio,
        icon: const Icon(Icons.play_arrow),
        label: const Text(AppStrings.resumeAudio),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final question = widget.controller.question;
    final subControllers = widget.controller.subControllers;

    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 32),
          Text(question.question,
              style: theme.textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          _buildActionButton(),
          const SizedBox(width: 32),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                Slider(
                  value: _position.inMilliseconds
                      .clamp(0, _duration.inMilliseconds)
                      .toDouble(),
                  max: _duration.inMilliseconds.toDouble(),
                  onChanged: (value) {
                    _player.seek(Duration(milliseconds: value.toInt()));
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_position)),
                    Text(_formatDuration(_duration)),
                  ],
                )
              ],
            ),
          ),
          const SizedBox(height: 32),
          ...List.generate(
            subControllers.length,
            (index) => Padding(
              padding: const EdgeInsets.only(bottom: 32),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.all(ThemeDefaults.padding),
                child: _buildSubQuestion(index, subControllers[index]),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
