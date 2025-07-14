import 'package:flutter/material.dart';

enum QuestionTopic
{
  human,
  home,
  school,
  work,
  social,
  food,
  services,
  travel,
  culture,
  sport,
  health,
  science,
  nature,
  politcs;


  static QuestionTopic fromString(String value) {
    switch (value) {
      case 'human':
        return QuestionTopic.human;
      case 'home':
        return QuestionTopic.home;
      case 'school':
        return QuestionTopic.school;
      case 'work':
        return QuestionTopic.work;
      case 'social':
        return QuestionTopic.social;
      case 'food':
        return QuestionTopic.food;
      case 'services':
        return QuestionTopic.services;
      case 'travel':
        return QuestionTopic.travel;
      case 'culture':
        return QuestionTopic.culture;
      case 'sport':
        return QuestionTopic.sport;
      case 'health':
        return QuestionTopic.health;
      case 'science':
        return QuestionTopic.science;
      case 'nature':
        return QuestionTopic.nature;
      case 'politcs':
        return QuestionTopic.politcs;
      default:
        throw ArgumentError('Invalid QuestionTopic: $value');
    }
  }

  static String stringDesc(QuestionTopic type)
  {
    switch (type) {
      case QuestionTopic.human:
        return "Człowiek";
      case QuestionTopic.home:
        return "Dom";
      case QuestionTopic.school:
        return "Szkoła";
      case QuestionTopic.work:
        return "Praca";
      case QuestionTopic.social:
        return "Życie rodzinne i towarzyskie";
      case QuestionTopic.food:
        return "Żywienie";
      case QuestionTopic.services:
        return "Zakupy i usługi";
      case QuestionTopic.travel:
        return "Podróżowanie i turystyka";
      case QuestionTopic.culture:
        return "Kultura";
      case QuestionTopic.sport:
        return "Sport";
      case QuestionTopic.health:
        return "Zdrowie";
      case QuestionTopic.science:
        return "Nauka";
      case QuestionTopic.nature:
        return "Świat przyrody";
      case QuestionTopic.politcs:
        return "Państwo i społeczeństwo";
    }
  }

  static IconData getIcon(QuestionTopic topic) {
    switch (topic) {
      case QuestionTopic.human:
        return Icons.person;
      case QuestionTopic.home:
        return Icons.home;
      case QuestionTopic.school:
        return Icons.school;
      case QuestionTopic.work:
        return Icons.work;
      case QuestionTopic.social:
        return Icons.group;
      case QuestionTopic.food:
        return Icons.restaurant;
      case QuestionTopic.services:
        return Icons.shopping_cart;
      case QuestionTopic.travel:
        return Icons.flight;
      case QuestionTopic.culture:
        return Icons.palette;
      case QuestionTopic.sport:
        return Icons.sports_soccer;
      case QuestionTopic.health:
        return Icons.local_hospital;
      case QuestionTopic.science:
        return Icons.science;
      case QuestionTopic.nature:
        return Icons.eco;
      case QuestionTopic.politcs:
        return Icons.account_balance;
    }
  }
}