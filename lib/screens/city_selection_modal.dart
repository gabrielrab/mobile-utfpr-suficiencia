import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CitySelectionModal extends StatefulWidget {
  @override
  _CitySelectionModalState createState() => _CitySelectionModalState();
}

class _CitySelectionModalState extends State<CitySelectionModal> {
  final _stateController = TextEditingController();
  final _cityController = TextEditingController();
  List<Map<String, String>> _states = [];
  List<String> _cities = [];

  @override
  void initState() {
    super.initState();
    _fetchStates();
  }

  Future<void> _fetchStates() async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        _states = data
            .map((state) => {
                  'nome': state['nome'] as String,
                  'sigla': state['sigla'] as String
                })
            .toList();
      });
    } else {
      throw Exception('Erro buscando os estados');
    }
  }

  Future<void> _fetchCities(String stateCode) async {
    final response = await http.get(Uri.parse(
        'https://servicodados.ibge.gov.br/api/v1/localidades/estados/$stateCode/municipios'));
    if (response.statusCode == 200) {
      final data = json.decode(response.body) as List;
      setState(() {
        _cities = data.map((city) => city['nome'] as String).toList();
      });
    } else {
      throw Exception('Erro buscando as cidades');
    }
  }

  void _onStateSelected(String state) {
    _cityController.clear();
    String stateCode = _states.firstWhere((s) => s['nome'] == state)['sigla']!;
    _fetchCities(stateCode);
  }

  void _confirmSelection() {
    Navigator.of(context).pop({
      'state': _stateController.text,
      'city': _cityController.text,
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Locais'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Estado'),
            items: _states.map((state) {
              return DropdownMenuItem(
                value: state['nome'],
                child: Text(state['nome']!),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _stateController.text = value;
                _onStateSelected(value);
              }
            },
          ),
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(labelText: 'Cidade'),
            items: _cities.map((city) {
              return DropdownMenuItem(
                value: city,
                child: Text(city),
              );
            }).toList(),
            onChanged: (value) {
              if (value != null) {
                _cityController.text = value;
              }
            },
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('Cancelar'),
        ),
        TextButton(
          onPressed: _confirmSelection,
          child: const Text('Ok'),
        ),
      ],
    );
  }
}
