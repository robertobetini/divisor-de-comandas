import 'package:divisao_contas/validators/validator.dart';
import 'package:flutter/material.dart';
import '../custom_widgets/constrained_text_field.dart';
import '../constants.dart';
import '../repositories/settings_repository.dart';
import '../validators/pix_validator.dart';
import '../models/pix_type.dart';

final settingsRepository = SettingsRepository();

final pixCpfValidator = PixCpfValidator();
final pixPhoneValidator = PixPhoneValidator();
final pixRandomKeyValidator = PixRandomKeyValidator();

MaterialPageRoute createPixConfigurationRoute(BuildContext context) {
  return PixConfigurationPageRoute(builder: (context) => const PixConfigurationPage(title: "Configurar chave PIX"));
}

class PixConfigurationPageRoute extends MaterialPageRoute<void> {
  PixConfigurationPageRoute({ required super.builder });
}

class PixConfigurationPage extends StatefulWidget {
  const PixConfigurationPage({ required this.title });

  final String title;

  @override
  State<PixConfigurationPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<PixConfigurationPage> {
  late TextEditingController nameController;
  late TextEditingController pixKeyController;

  var _includePixOnPdf = settingsRepository.getPreference<bool>(Constants.settingsIncludePixOnPdfParam) ?? false;
  var _pixKeyType = settingsRepository.getPreference<PixType>(Constants.settingsPixKeyTypeParam) ?? PixType.cpf;  

  @override
  void initState() {
    super.initState();
    var currentName = settingsRepository.getPreference<String>(Constants.settingsCurrentNameParam) ?? "";
    var currentPixKey = settingsRepository.getPreference<String>(Constants.settingsCurrentPixKeyParam) ?? "";

    nameController = TextEditingController(text: currentName);
    pixKeyController = TextEditingController(text: currentPixKey);
  }

  @override
  void dispose() {
    nameController.dispose();
    pixKeyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Configurar chave PIX"),
      ),
      body: Column(
        spacing: 5,
        children: [
          ListTile(
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.power_settings_new),
                Switch(
                  value: _includePixOnPdf, 
                  onChanged: (value) {
                    setState(() {
                      _includePixOnPdf = value;
                      settingsRepository.setPreference(Constants.settingsIncludePixOnPdfParam, _includePixOnPdf);
                    });
                  }
                )
              ],
            )
          ),
          ListTile(
            key: ValueKey("name-$_includePixOnPdf"), 
            title: ConstrainedTextField(nameController, "Nome", 25, enabled: _includePixOnPdf)
          ),
          ListTile(
            key: ValueKey("pixKey-$_includePixOnPdf"), 
            title: ConstrainedTextField(pixKeyController, "Pix", 36, enabled: _includePixOnPdf)
          ),
          RadioGroup(
            onChanged: (value) => setState(() => _pixKeyType = value!), 
            groupValue: _pixKeyType,
            child: Row(
              children: PixType.values
                .map((type) => Row(
                  children: [
                    Radio<PixType>(
                      enabled: _includePixOnPdf,
                      value: type
                    ),
                    Text(type.friendlyName)
                  ],
                ))
                .toList()
            )
          ),
          SizedBox(height: 12),
          ElevatedButton(
            onPressed: !_includePixOnPdf ? null : () {
              var name = nameController.text.toUpperCase().trim();
              var pixKey = pixKeyController.text.trim();

              var pixValidator = resolvePixValidator(_pixKeyType);

              var pixKeyValidationResult = pixValidator.validate(pixKey);
              if (!pixKeyValidationResult.isSuccess) {
                showDialog(
                  context: context, 
                  builder: (context) => AlertDialog(
                    title: Text("Erro"),
                    content: Text("Chave pix do tipo '${_pixKeyType.friendlyName}' inválida"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context), 
                        child: Text("OK")
                      )
                    ],
                  ));

                return;
              }

              setState(() {
                settingsRepository.setPreference(Constants.settingsCurrentNameParam, name);
                settingsRepository.setPreference(Constants.settingsCurrentPixKeyParam, pixKeyValidationResult.value);
                settingsRepository.setPreference(Constants.settingsPixKeyTypeParam, _pixKeyType);
              });

              Navigator.pop(context);
            }, 
            child: Text("Salvar")
          )
        ],
      )
    );
  }
}

Validator<String> resolvePixValidator(PixType type) {
  switch (type) {
    case PixType.cpf:
      return pixCpfValidator;
    case PixType.phone:
      return pixPhoneValidator;
    case PixType.random:
      return pixRandomKeyValidator;
  }
}
