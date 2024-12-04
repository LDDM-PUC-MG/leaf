import 'package:calendar_slider/calendar_slider.dart';
import 'package:calendario/database/sql_helper.dart';
import 'package:calendario/database/user.dart';
import 'package:calendario/database/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart'; // Import para pegar imagens
import 'dart:io'; // Para manipular arquivos de imagem
import 'package:calendario/styles/colors.dart';
import 'package:calendario/screens/maps.dart';
import 'package:provider/provider.dart';

class Memorias extends StatefulWidget {
  const Memorias({super.key});

  @override
  State<Memorias> createState() => _ExamplePageState();
}

class _ExamplePageState extends State<Memorias> {
  final CalendarSliderController _firstController = CalendarSliderController();
  late DateTime dataSelecionada;
  final Map<DateTime, Map<String, dynamic>> _memoria =
      {}; // Mapa para armazenar anotações e imagens
  List<File> imgSelecionadas = []; // Armazena as imagens selecionadas

  late UserProvider userProvider;
  late User user;

  // Função para exibir o diálogo para anotações
  void _salvarMemoria(BuildContext context) {
    TextEditingController noteController = TextEditingController(
      text: _memoria[dataSelecionada]?['text'] ??
          '', // Preenche com a anotação existente se houver
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: const Text("Memória do Dia")),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.place),
                    onPressed: () async {
                      // Código para seleção de localização
                    },
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: noteController,
                      decoration: const InputDecoration(
                        hintText: "Digite aqui",
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem salvar
              },
            ),
            ElevatedButton(
              child: const Text("Salvar"),
              onPressed: () async {
                // Adiciona a memória no SQLite
                await SQLHelper.addMemoria(
                  user.id, // ID do usuário
                  noteController.text,
                  dataSelecionada.toIso8601String().substring(0, 10),
                );

                setState(() {
                  _memoria[dataSelecionada] = {'text': noteController.text};
                });

                Navigator.of(context).pop(); // Fecha o diálogo ao salvar
              },
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

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Editar Memória"),
          content: TextField(
            controller: noteController,
            decoration: const InputDecoration(
              hintText: "Digite aqui",
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            ElevatedButton(
              child: const Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop(); // Fecha o diálogo sem salvar
              },
            ),
            ElevatedButton(
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
                  _memoria[dataSelecionada] = {'text': noteController.text};
                });

                Navigator.of(context).pop(); // Fecha o diálogo ao salvar
              },
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

  Future<void> _escolherImgs() async {
    final ImagePicker picker = ImagePicker();
    final List<XFile> pickedFiles = await picker.pickMultiImage();

    setState(() {
      imgSelecionadas = pickedFiles.map((file) => File(file.path)).toList();
    });
  }

  Widget _buildImageGallery() {
    return Wrap(
      alignment: WrapAlignment.center, // Centraliza as imagens
      spacing: 20,
      runSpacing: 10,
      children: imgSelecionadas.map((image) {
        return GestureDetector(
          onTap: () {
            _openFullScreenImage(image);
          },
          child: SizedBox(
            width: 100,
            height: 100,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _openFullScreenImage(File image) {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          child: GestureDetector(
            onTap: () {
              Navigator.of(context).pop(); // Fecha a tela cheia ao clicar
            },
            child: Image.file(
              image,
              fit: BoxFit.contain,
            ),
          ),
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
            'id': memoriaDoDia['id'], // Armazene o ID da memória
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
                        const SizedBox(height: 10),
                        _memoria[dataSelecionada]?['images'] != null
                            ? _buildImageGallery()
                            : Container(),
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
