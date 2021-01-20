bool needUpdate(int lastUpdate) {
  return lastUpdate == null ||
      DateTime.fromMillisecondsSinceEpoch(lastUpdate)
          .isBefore(DateTime.now().subtract(Duration(minutes: 2)));
}
