import 'package:calendar_slider/calendar_slider.dart';
import 'package:calendario/database/sql_helper.dart';
import 'package:calendario/database/user.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:io'; // Para manipular arquivos de imagem
import 'package:calendario/styles/colors.dart';
import 'package:calendario/screens/maps.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class Memorias extends StatefulWidget {
  const Memorias({super.key});

  @override
  State<Memorias> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Memorias> {
  final CalendarSliderController _firstController = CalendarSliderController();
  late DateTime dataSelecionada;
  final Map<DateTime, Map<String, dynamic>?> _memoria = {};

  List<File> imgSelecionadas = []; // Armazena as imagens selecionadas

  late UserProvider userProvider;
  late User user;

  // Função para exibir o diálogo para adicionar uma nova memória

  void _salvarMemoria(BuildContext context) {
    TextEditingController noteController = TextEditingController(
      text: _memoria[dataSelecionada]?['text'] ?? '',
    );

    stt.SpeechToText _speech = stt.SpeechToText();
    bool _isListening = false;

    void _startListening() async {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('Status: $val');
          if (val == "listening") {
            setState(() {
              _isListening = true;
            });
          } else if (val == "notListening") {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (val) => print('Error: $val'),
      );

      if (available) {
        _speech.listen(onResult: (val) {
          noteController.text =
              val.recognizedWords; // Substituir ao invés de concatenar
        });
      } else {
        print("Permissão para usar o microfone negada.");
      }
    }

    void _stopListening() {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Center(child: Text("Memória do Dia")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.place),
                    onPressed: () async {
                      // Navega para o mapa e obtém a localização selecionada
                      LatLng? location = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapaSelecionarLocalizacao(),
                        ),
                      );

                      if (location != null) {
                        // Converte a localização em texto e adiciona ao campo de texto
                        String locationText =
                            'Lat: ${location.latitude}, Lng: ${location.longitude}';
                        noteController.text =
                            locationText; // Atualiza o texto no campo
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      maxLines:
                          null, // Permite que o campo de texto expanda verticalmente
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isListening ? _stopListening : _startListening,
                icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                label: Text(_isListening ? "Parar" : "Gravar"),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // Ajusta a altura
                    ),
                    child: const Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                const SizedBox(width: 8), // Espaço entre os botões
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // Ajusta a altura
                    ),
                    child: const Text("Salvar"),
                    onPressed: () async {
                      await SQLHelper.addMemoria(
                        user.id,
                        noteController.text,
                        dataSelecionada.toIso8601String().substring(0, 10),
                      );

                      setState(() {
                        _memoria[dataSelecionada] = {
                          'text': noteController.text
                        };
                      });

                      Navigator.of(context).pop();
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _editarMemoria(BuildContext context) {
    final int? memoriaId = _memoria[dataSelecionada]?['id'];

    if (memoriaId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Nenhuma memória encontrada para este dia.")),
      );
      return;
    }

    TextEditingController noteController = TextEditingController(
      text: _memoria[dataSelecionada]?['text'] ?? '',
    );

    stt.SpeechToText _speech = stt.SpeechToText();
    bool _isListening = false;

    void _startListening() async {
      bool available = await _speech.initialize(
        onStatus: (val) {
          print('Status: $val');
          if (val == "listening") {
            setState(() {
              _isListening = true;
            });
          } else if (val == "notListening") {
            setState(() {
              _isListening = false;
            });
          }
        },
        onError: (val) => print('Error: $val'),
      );

      if (available) {
        _speech.listen(onResult: (val) {
          noteController.text = val.recognizedWords;
        });
      } else {
        print("Permissão para usar o microfone negada.");
      }
    }

    void _stopListening() {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Memória"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.place),
                    onPressed: () async {
                      // Navega para o mapa e obtém a localização selecionada
                      LatLng? location = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MapaSelecionarLocalizacao(),
                        ),
                      );

                      if (location != null) {
                        // Converte a localização em texto e adiciona ao campo de texto
                        String locationText =
                            'Lat: ${location.latitude}, Lng: ${location.longitude}';
                        noteController.text =
                            locationText; // Atualiza o texto no campo
                      }
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      maxLines:
                          null, // Permite que o campo de texto expanda verticalmente
                      keyboardType: TextInputType.multiline,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: _isListening ? _stopListening : _startListening,
                icon: Icon(_isListening ? Icons.mic_off : Icons.mic),
                label: Text(_isListening ? "Parar" : "Gravar"),
              ),
            ],
          ),
          actions: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // Ajusta a altura
                    ),
                    child: const Text("Cancelar"),
                    onPressed: () {
                      Navigator.of(context).pop(); // Fecha o diálogo sem salvar
                    },
                  ),
                ),
                const SizedBox(width: 8), // Espaço entre os botões
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 16), // Ajusta a altura
                    ),
                    child: const Text("Salvar"),
                    onPressed: () async {
                      // Atualiza a memória no SQLite
                      await SQLHelper.updateMemoria(
                        memoriaId, // Use o ID da memória
                        noteController.text,
                        dataSelecionada.toIso8601String().substring(0, 10),
                      );

                      // Atualiza o estado local
                      setState(() {
                        _memoria[dataSelecionada] = {
                          'id': memoriaId,
                          'text': noteController.text,
                        };
                      });

                      Navigator.of(context).pop(); // Fecha o diálogo ao salvar
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }

  void _msgPerdeuDia(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Mensagem"),
          content: const Text(
              "Não tem memória nesse dia!! Ou esqueceu-se, ou nem aconteceu!!"),
          actions: [
            TextButton(
              child: const Text("Ok"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    dataSelecionada = DateTime.now();

    Future<void> _carregarMemoriaParaDataAtual() async {
      List<Map<String, dynamic>> memoria = await SQLHelper.getMemorias(user.id);

      Map<String, dynamic>? memoriaDoDia = memoria.firstWhere(
        (mem) => mem['data']
            .startsWith(dataSelecionada.toIso8601String().substring(0, 10)),
        orElse: () => {},
      );

      if (mounted) {
        setState(() {
          _memoria[dataSelecionada] = {
            'text': memoriaDoDia['mensagem'] ?? '',
            'id': memoriaDoDia['id'], // Garante consistência de ID
          };
        });
      }
    }

    // Carregar o UserProvider e inicializar o usuário após o frame ser construído
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      userProvider = Provider.of<UserProvider>(context, listen: false);
      user = userProvider.user!;

      // Carregar a memória para o dia atual
      await _carregarMemoriaParaDataAtual();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          CalendarSlider(
              controller: _firstController,
              selectedDayPosition: SelectedDayPosition.center,
              fullCalendarScroll: FullCalendarScroll.vertical,
              backgroundColor: AppColors.primary,
              fullCalendarWeekDay: WeekDay.short,
              selectedTileBackgroundColor: Colors.white,
              monthYearButtonBackgroundColor: Colors.white,
              monthYearTextColor: Colors.black,
              tileBackgroundColor: AppColors.secondary,
              selectedDateColor: Colors.black,
              dateColor: Colors.white,
              tileShadow: BoxShadow(
                color: Colors.black.withOpacity(1),
              ),
              locale: 'pt-br',
              initialDate: DateTime.now(),
              firstDate: DateTime.now().subtract(const Duration(days: 100)),
              lastDate: DateTime.now().add(const Duration(days: 100)),
              onDateSelected: (date) async {
                setState(() {
                  dataSelecionada = date;
                  imgSelecionadas =
                      _memoria[date]?['images'] ?? []; // Carrega imagens salvas
                });

                List<Map<String, dynamic>> memoria =
                    await SQLHelper.getMemorias(user.id);

                Map<String, dynamic>? memoriaDoDia = memoria.firstWhere(
                  (mem) => mem['data']
                      .startsWith(date.toIso8601String().substring(0, 10)),
                  orElse: () => {},
                );

                setState(() {
                  _memoria[dataSelecionada] = memoriaDoDia.isNotEmpty
                      ? {
                          'text': memoriaDoDia['mensagem'] ?? '',
                          'id': memoriaDoDia['id'], // Adiciona o ID ao mapa
                        }
                      : {'text': null, 'id': null}; // Garante valores padrão
                });
              }),
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            _firstController.goToDay(DateTime.now());
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text(
                            "Voltar para hoje",
                            style: TextStyle(
                              color: AppColors.terciary,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            DateTime hoje = DateTime.now();
                            DateTime ontem =
                                hoje.subtract(const Duration(days: 1));

                            if ((dataSelecionada.day == hoje.day &&
                                    dataSelecionada.month == hoje.month &&
                                    dataSelecionada.year == hoje.year) ||
                                (dataSelecionada.day == ontem.day &&
                                    dataSelecionada.month == ontem.month &&
                                    dataSelecionada.year == ontem.year)) {
                              if (_memoria[dataSelecionada]?['text'] != null) {
                                // Editar memória existente
                                _editarMemoria(context);
                              } else {
                                // Adicionar nova memória
                                _salvarMemoria(context);
                              }
                            } else {
                              _msgPerdeuDia(context);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                          ),
                          child: Text(
                            _memoria[dataSelecionada]?['text'] != null
                                ? "Editar Memória"
                                : "Adicionar Memória",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 16.0),
                    padding: const EdgeInsets.all(16.0),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundSecondary,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 2.0,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _memoria[dataSelecionada]?['text'] != null
                              ? '${_memoria[dataSelecionada]?['text']}\n'
                              : "Sem recordação",
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.left,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
