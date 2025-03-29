import 'package:flutter/material.dart';

//app name
const appName = 'Ai Buddy';

//media query to store size of device screen
late Size mq;

//helper (mapping list with index)
extension FicListExtension<T> on List<T> {
  Iterable<E> mapIndexed<E>(E Function(int index, T item) map) sync* {
    for (var index = 0; index < length; index++) {
      yield map(index, this[index]);
    }
  }
}

// TODO Chat Gpt Api key OR
//  Google Gemini API Key - https://aistudio.google.com/app/apikey
//  You need to Update it in your Appwrite Project or comment appwrite code and hardcord key here.

String apiKey = '';
