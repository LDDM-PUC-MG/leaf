import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendario/styles/colors.dart';


class TableEventsExample extends StatefulWidget {
  const TableEventsExample({super.key});

  @override
  _TableEventsExampleState createState() => _TableEventsExampleState();
}

class _TableEventsExampleState extends State<TableEventsExample> {
  late final ValueNotifier<List<Event>> _selectedEvents;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  RangeSelectionMode _rangeSelectionMode = RangeSelectionMode.toggledOff;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  DateTime? _rangeStart;
  DateTime? _rangeEnd;

  @override
  void initState() {
    super.initState();

    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  List<Event> _getEventsForDay(DateTime day) {
    return kEvents[day] ?? [];
  }

  List<Event> _getEventsForRange(DateTime start, DateTime end) {
    final days = daysInRange(start, end);
    return [for (final d in days) ..._getEventsForDay(d)];
  }

  void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
    if (!isSameDay(_selectedDay, selectedDay)) {
      setState(() {
        _selectedDay = selectedDay;
        _focusedDay = focusedDay;
        _rangeStart = null;
        _rangeEnd = null;
        _rangeSelectionMode = RangeSelectionMode.toggledOff;
      });

      _selectedEvents.value = _getEventsForDay(selectedDay);
    }
  }

  void _onRangeSelected(DateTime? start, DateTime? end, DateTime focusedDay) {
    setState(() {
      _selectedDay = null;
      _focusedDay = focusedDay;
      _rangeStart = start;
      _rangeEnd = end;
      _rangeSelectionMode = RangeSelectionMode.toggledOn;
    });

    if (start != null && end != null) {
      _selectedEvents.value = _getEventsForRange(start, end);
    } else if (start != null) {
      _selectedEvents.value = _getEventsForDay(start);
    } else if (end != null) {
      _selectedEvents.value = _getEventsForDay(end);
    }
  }

  Future<void> _addEventDialog() async {
    TextEditingController eventController = TextEditingController();

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Adicionar Evento"),
        content: TextField(
          controller: eventController,
          decoration: InputDecoration(hintText: "Título do evento"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              if (eventController.text.isNotEmpty) {
                setState(() {
                  if (kEvents[_selectedDay!] != null) {
                    kEvents[_selectedDay!]!.add(Event(eventController.text));
                  } else {
                    kEvents[_selectedDay!] = [Event(eventController.text)];
                  }
                  _selectedEvents.value = _getEventsForDay(_selectedDay!);
                });
                Navigator.pop(context);
              }
            },
            child: Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  void _removeEvent() {
    if (_selectedDay != null && kEvents[_selectedDay!] != null && kEvents[_selectedDay!]!.isNotEmpty) {
      setState(() {
        kEvents[_selectedDay!]!.removeLast();
        _selectedEvents.value = _getEventsForDay(_selectedDay!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calendário'),
      ),
      body: Column(
        children: [
          TableCalendar<Event>(
            firstDay: kFirstDay,
            lastDay: kLastDay,
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            rangeStartDay: _rangeStart,
            rangeEndDay: _rangeEnd,
            calendarFormat: _calendarFormat,
            rangeSelectionMode: _rangeSelectionMode,
            eventLoader: _getEventsForDay,
            startingDayOfWeek: StartingDayOfWeek.monday,
            calendarStyle: CalendarStyle(
              outsideDaysVisible: false,
            ),
            onDaySelected: _onDaySelected,
            onRangeSelected: _onRangeSelected,
            onFormatChanged: (format) {
              if (_calendarFormat != format) {
                setState(() {
                  _calendarFormat = format;
                });
              }
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(
            child: ValueListenableBuilder<List<Event>>(
              valueListenable: _selectedEvents,
              builder: (context, value, _) {
                return ListView.builder(
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12.0,
                        vertical: 4.0,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: ListTile(
                        onTap: () => print('${value[index]}'),
                        title: Text('${value[index]}'),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _selectedDay != null
          ? Padding(
        padding: const EdgeInsets.only(bottom: 15.0), // Aumenta a margem inferior
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              onPressed: _removeEvent,
              label: Text(
                "Remover Evento",
                style: TextStyle(color: AppColors.white), // Define a cor da fonte
              ),
              icon: Icon(Icons.remove, color:AppColors.white),
              backgroundColor: Colors.red,
            ),

            FloatingActionButton.extended(
              onPressed: _addEventDialog,
              label: Text(
                "Adicionar Evento",
                style: TextStyle(color: AppColors.white), // Define a cor da fonte
              ),
              icon: Icon(Icons.add, color:AppColors.white),
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
      )

          : null,
    );
  }
}

// Example events data
class Event {
  final String title;
  Event(this.title);

  @override
  String toString() => title;
}

final kFirstDay = DateTime(2020, 1, 1);
final kLastDay = DateTime(2030, 12, 31);

final Map<DateTime, List<Event>> kEvents = {};

// Helper functions
List<DateTime> daysInRange(DateTime start, DateTime end) {
  return List.generate(
    end.difference(start).inDays + 1,
        (index) => DateTime(start.year, start.month, start.day + index),
  );
}

bool isSameDay(DateTime? day1, DateTime? day2) {
  if (day1 == null || day2 == null) return false;
  return day1.year == day2.year && day1.month == day2.month && day1.day == day2.day;
}