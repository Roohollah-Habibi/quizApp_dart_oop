import 'dart:ffi';
import 'dart:io';

enum Category { multiChoice, trueFalseChoice }

const msg = 'Out of question ;-( to view your score type[v] instructions[i]';

void main() {
  Quiz myQuiz = Quiz();
  myQuiz.startQuiz(start: true); // it should be true to make our quiz running...
  myQuiz.quizInstructions();
  while (myQuiz.getStart) {
    stdout.write('choice: ');
    String? userAns = stdin.readLineSync().toString().toLowerCase();
    switch (userAns) {
      case 'q':
        myQuiz.setStart = false;
        print('Have a good day!');
        break;
      case 't':
        myQuiz.showQuestionsCategory(Category.trueFalseChoice);
        print('Instructions: type [t]rue /  [f]alse');
        int questionCounter = 0;
        trueFalseMethod(myQuiz, questionCounter);
      case 'm':
        myQuiz.showQuestionsCategory(Category.multiChoice);
        print('Instructions: type letter of the correct number [a/b/c/d]');
        int questionsCounter = 0;
        multiChoiceQuestions(myQuiz, questionsCounter);
      case 'v':
        myQuiz.showScore();
      case 'i':
        myQuiz.quizInstructions();
      default:
        print('Invalid input type i to view instructions');
    }
  }
}

void multiChoiceQuestions(Quiz myQuiz, int questionsCounter) {
  List<List<String>> myValues = Questions._answers;
  for (int i = 0; i < myValues.length; i++) {
    questionsCounter++;
    String question = Questions._multipleChoice.keys.toList()[i];
    print('$questionsCounter -$question');
    for (int j = 0; j < myValues[i].length-1; j++) {
      print('\t\t${String.fromCharCode(97 + j)}: ${myValues[i][j]}');
    }
    stdout.write('Select: ');
    String userInput = stdin.readLineSync().toString().toLowerCase();
    int indexAnswer = 0;
    switch (userInput) {
      case 'a':
        indexAnswer = 0;
      case 'b':
        indexAnswer = 1;
      case 'c':
        indexAnswer = 2;
      case 'd':
        indexAnswer = 3;
    }
    if (myValues[i][indexAnswer] == myValues[i][4]) {
      myQuiz.setScore = myQuiz.getScore + 1;
    }
  }
  if (questionsCounter == Questions._multipleChoice.length) {
    print(msg);
  }
}

void trueFalseMethod(Quiz myQuiz, int questionCounter) {
  for (var question in Questions._trueFalseQuestions.entries) {
    questionCounter++;
    stdout.write('$questionCounter  -${question.key}');
    String? userInputInString = stdin.readLineSync().toString().toLowerCase();
    if (userInputInString == question.value.toString() ||
        (userInputInString == 't' &&
            question.value.toString().startsWith('t')) ||
        (userInputInString == 'f' &&
            question.value.toString().startsWith('f'))) {
      myQuiz.setScore = myQuiz.getScore + 1;
    }

    if (Questions._trueFalseQuestions.length == questionCounter) {
      print(msg);
      break;
    }
  }
}

// 5- Create a simple quiz application using OOP that allows users to play and
// view their score.
class Quiz {
  static bool _start = false;
  int _score = 0;
  String? _questionCategory;

  Quiz() {
    print('\n\n\t\t\t=======> Welcome to Quiz App <=======');
  }

  bool get getStart => _start;

  get getCategory => _questionCategory!;

  int get getScore => _score;

  set setStart(bool start) => _start = start;

  set setScore(int value) => _score = value;

  void quizInstructions() {
    if (Quiz._start) {
      print('Instructions:\n'
          '1-[m] for multi choice questions\n'
          '2-[t] for trueFalse questions\n'
          '3-[v] to view your score\n'
          '4-[q] to quit the game');
    } else {
      print(
          'make sure you make the quiz app enable in main method by quizApp.startQuiz before testing \n');
    }
  }

  bool startQuiz({required bool start}) => _start = start; // to Start the app

  // showing questions category
  void showQuestionsCategory(Category choice) {
    setScore = 0;
    if (getStart) {
      if (choice.name == 'multiChoice') {
        _questionCategory = 'multiChoice';
      } else if (choice.name == 'trueFalseChoice') {
        _questionCategory = 'trueFalseChoice';
      }
    } else {
      print('you have not started the quiz yet try [.startQuiz()]');
    }
  }

// Show Score Method
  void showScore() {
    if (_questionCategory == null) {
      print(
          'test yourself with t/f or multi choice questions before checking scores');
      return;
    }
    int questionsLength = (getCategory == 'trueFalseChoice')
        ? Questions._trueFalseQuestions.length
        : Questions._multipleChoice.length;
    final reaction = ((getScore * 100 / questionsLength) >= 70)
        ? 'Per😍fect'
        : ((getScore * 100 / questionsLength) >= 50)
            ? 'G😊Od'
            : '🤦‍♂️😢';
    print(
        'you answered $_score out of $questionsLength questions in [$getCategory]test $reaction');
  }
}

//Questions Library
abstract class Questions {
  static final Map<String, bool> _trueFalseQuestions = {
    'The ocean is salty: ': true,
    'Penguins can fly: ': false,
    'The Earth is round: ': true,
    'Seeds grow into plants: ': true,
    'All insects have six legs: ': true,
    'The sun is a giant ball of fire: ': true,
    'Apples grow on vines: ': false,
    'All butterflies are colorful: ': true,
    'Do all cars have four wheels? ': true,
    'Is a cat a type of fish? ': false,
    'Does water flow uphill? ': false,
    'Do birds have wings? ': true,
    'Is grass green? ': true,
    'Do dogs bark? ': true,
    'Does the sun come out at night? ': false,
    'Are books made of paper? ': true,
    'Do clouds float in the sky? ': true,
    'Do trees have leaves? ': true,
    'Rocks are soft: ': false,
    'Elephants can fly: ': false,
  };
  static final Map<String, List<String>> _multipleChoice = {
    'What is the largest animal in the world?': [
      'elephant',
      'giraffe',
      'blue whale',
      'brown bear',
      'blue whale',
    ],
    'What is the name of the world’s highest mountain?': [
      'Alps',
      'Mount Everest',
      'Zugspitze',
      'Annapurna',
      'Mount Everest',
    ],
    'How many wings does a butterfly have?': [ '2', '6','4', '5','4'],
    'At what age do teenagers become an adult in the UK? ': [
      '18',
      '16',
      '20',
      '21',
      '18',
    ],
    'How many planets are there in our solar system? ': [ '5', '7','8', '9','8',],
    'How many players are there in a football team?': ['11', '9', '10', '12','11',],
    'A lobster has how many legs?': [ '8', '21', '4','10','10',],
    'How long is an hour in minutes?': [ '10', '100','60', '600','60',],
    'What do you call a baby dog?': ['puppy', 'foal', 'piglet', 'kitten','puppy',],
    'What language do people from Spain speak?': [
      'Spanish',
      'German',
      'French',
      'English',
      'Spanish',
    ],

    'What is the 6th letter in the alphabet?': [ 'E','F', 'H', 'J','F',],
  };

  static final List<List<String>> _answers = _multipleChoice.values.toList();

  // static List<List<String>> shuffleAnswers() {
  //   List<List<String>> shList = [];
  //   for (var item in _answers) {
  //     item.shuffle();
  //     shList.add(item);
  //   }
  //   return shList;
  // }
}
