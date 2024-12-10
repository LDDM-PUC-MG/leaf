import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
class MapaSelecionarLocalizacao extends StatefulWidget {
  @override
  _MapaSelecionarLocalizacaoState createState() => _MapaSelecionarLocalizacaoState();
}
class _MapaSelecionarLocalizacaoState extends State<MapaSelecionarLocalizacao> {
  late GoogleMapController mapController;
  LatLng? selectedLocation; // Para armazenar a localização selecionada
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Selecione uma Localização'),
      ),
      body: GoogleMap(
        onMapCreated: (GoogleMapController controller) {
          mapController = controller;
        },
        initialCameraPosition: CameraPosition(
          target: LatLng(-22.9068, -43.1729), // Coordenadas iniciais
          zoom: 10,
        ),
        onTap: (LatLng location) {
          setState(() {
            selectedLocation = location; // Atualiza a localização selecionada
          });
        },
        markers: selectedLocation != null
            ? {
          Marker(
            markerId: MarkerId('selected-location'),
            position: selectedLocation!,
          ),
        }
            : {},
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (selectedLocation != null) {
            Navigator.pop(context, selectedLocation); // Retorna a localização selecionada
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Selecione uma localização no mapa')),
            );
          }
        },
        child: Icon(Icons.check),
      ),
    );
  }
}
