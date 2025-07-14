import '../../core/constants.dart';
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
        return AppStrings.topicHuman;
      case QuestionTopic.home:
        return AppStrings.topicHome;
      case QuestionTopic.school:
        return AppStrings.topicSchool;
      case QuestionTopic.work:
        return AppStrings.topicWork;
      case QuestionTopic.social:
         return AppStrings.topicSocial;
      case QuestionTopic.food:
         return AppStrings.topicFood;
      case QuestionTopic.services:
         return AppStrings.topicServices;
      case QuestionTopic.travel:
         return AppStrings.topicTravel;
      case QuestionTopic.culture:
         return AppStrings.topicCulture;
      case QuestionTopic.sport:
         return AppStrings.topicSport;
      case QuestionTopic.health:
         return AppStrings.topicHealth;
      case QuestionTopic.science:
         return AppStrings.topicScience;
      case QuestionTopic.nature:
         return AppStrings.topicNature;
      case QuestionTopic.politcs:
         return AppStrings.topicPolitcs;
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