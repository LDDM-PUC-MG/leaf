import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:calendario/styles/colors.dart';
import 'package:calendario/database/sql_helper.dart'; // Certifique-se de importar o SQLHelper para a interação com o banco de dados.

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

  Map<DateTime, List<Event>> _events = {}; // Local map to store events temporarily.

  final int idUsuario = 1; // Supondo que o id do usuário seja 1. Ajuste conforme necessário.

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));

    _loadAllEvents(); // Load all events from the database on init.
  }

  @override
  void dispose() {
    _selectedEvents.dispose();
    super.dispose();
  }

  Future<void> _loadAllEvents() async {
    _events.clear();
    final allEvents = await SQLHelper.getAllEvents(idUsuario); // Passa o idUsuario como argumento.
    for (var event in allEvents) {
      DateTime eventDate = DateTime.parse(event['data']);
      if (_events[eventDate] != null) {
        _events[eventDate]!.add(Event(event['titulo'], event['id']));
      } else {
        _events[eventDate] = [Event(event['titulo'], event['id'])];
      }
    }

    setState(() {
      _selectedEvents.value = _getEventsForDay(_selectedDay!);
    });
  }

  List<Event> _getEventsForDay(DateTime day) {
    return _events[day] ?? [];
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
        title: const Text("Adicionar Evento"),
        content: TextField(
          controller: eventController,
          decoration: const InputDecoration(hintText: "Título do evento"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () async {
              if (eventController.text.isNotEmpty && _selectedDay != null) {
                final data =
                    '${_selectedDay!.year}-${_selectedDay!.month.toString().padLeft(2, '0')}-${_selectedDay!.day.toString().padLeft(2, '0')}';

                // Adicionar evento ao banco de dados SQLite
                await SQLHelper.addCalendarEvent(
                  idUsuario, // Passando o id do usuário autenticado.
                  eventController.text,
                  data,
                );

                await _loadAllEvents(); // Recarrega todos os eventos no calendário.
                _selectedEvents.value = _getEventsForDay(_selectedDay!);
                Navigator.pop(context); // Fecha o diálogo
              }
            },
            child: const Text("Adicionar"),
          ),
        ],
      ),
    );
  }

  Future<void> _removeEvent(int eventId) async {
    // Remove evento do banco de dados pelo ID.
    await SQLHelper.removeCalendarEvent(eventId);
    await _loadAllEvents(); // Recarrega os eventos do banco de dados.
    _selectedEvents.value = _getEventsForDay(_selectedDay!);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Calendário'),
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
            calendarStyle: const CalendarStyle(
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
                        title: Text(value[index].title),
                        trailing: IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () async {
                            await _removeEvent(value[index].id!); // Remove evento pelo ID.
                          },
                        ),
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
        padding: const EdgeInsets.only(bottom: 15.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            FloatingActionButton.extended(
              onPressed: _addEventDialog,
              label: const Text(
                "Adicionar Evento",
                style: TextStyle(color: AppColors.white),
              ),
              icon: const Icon(Icons.add, color: AppColors.white),
              backgroundColor: AppColors.secondary,
            ),
          ],
        ),
      )
          : null,
    );
  }
}

// Event class with ID support for database.
class Event {
  final String title;
  final int? id; // Add an ID to track events from the database.

  Event(this.title, [this.id]);

  @override
  String toString() => title;
}

final kFirstDay = DateTime(2020, 1, 1);
final kLastDay = DateTime(2030, 12, 31);

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
