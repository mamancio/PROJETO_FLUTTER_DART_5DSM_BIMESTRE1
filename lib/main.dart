import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

void main() => runApp(
      AppData(
        contatos: [],
        transferencias: [],
        child: const APPBanco(),
      ),
    );

class AppData extends InheritedWidget {
  final List<Contato> contatos;
  final List<Transferencia> transferencias;

  AppData({
    required this.contatos,
    required this.transferencias,
    required Widget child,
  }) : super(child: child);

  static AppData? of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppData>();
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }
}

class APPBanco extends StatelessWidget {
  const APPBanco({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APP Banco',
      home: Scaffold(
        body: Dashboard(),
      ),
    );
  }
}

//============== DASHBOARD =========================
class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<StatefulWidget> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BANK NACIONAL",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: const Color.fromARGB(249, 223, 127, 17),
      ),
      body: GridView.count(
        padding: const EdgeInsets.all(10.0),
        scrollDirection: Axis.horizontal,
        crossAxisCount: 4,
        crossAxisSpacing: 10.0,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListaContatos()),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 46, 94, 226),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.contacts,
                    size: 40.0,
                    color: Colors.black,
                  ),
                  SizedBox(height: 50.0),
                  Text("Contatos", style: TextStyle(fontSize: 16.0)),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ListaTransferencias(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              color: const Color.fromARGB(255, 45, 189, 40),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(
                    Icons.attach_money,
                    size: 40.0,
                    color: Colors.black,
                  ),
                  SizedBox(height: 50.0),
                  Text(
                    'Transferências',
                    style: TextStyle(fontSize: 16.0),
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

//============== LISTA DE CONTATOS =============================
class ListaContatos extends StatefulWidget {
  @override
  _ListaContatosState createState() => _ListaContatosState();
}

class _ListaContatosState extends State<ListaContatos> {
  @override
  Widget build(BuildContext context) {
    final contatos = AppData.of(context)!.contatos;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Contatos'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        itemCount: contatos.length,
        itemBuilder: (context, index) {
          final contato = contatos[index];
          return Card(
            child: ListTile(
              leading: const Icon(Icons.person, color: Colors.blue),
              title: Text(contato.nome),
              subtitle: Text(contato.email),
              trailing: const Icon(Icons.phone, color: Colors.green),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Contato? contatoRecebido = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioContato()),
          );

          if (contatoRecebido != null) {
            setState(() {
              contatos.add(contatoRecebido);
            });
          }
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
    );
  }
}

//============== FORMULARIO DE CONTATOS ============================
class FormularioContato extends StatelessWidget {
  final TextEditingController _controllerNome = TextEditingController();
  final TextEditingController _controllerEndereco = TextEditingController();
  final TextEditingController _controllerTelefone = TextEditingController();
  final TextEditingController _controllerEmail = TextEditingController();
  final TextEditingController _controllerCpf = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Contato'),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        // Adiciona rolagem
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Editor(
              controlador: _controllerNome,
              rotulo: 'Nome',
              dica: 'João Silva',
            ),
            Editor(
              controlador: _controllerEndereco,
              rotulo: 'Endereço',
              dica: 'Rua Exemplo, 123',
            ),
            Editor(
              controlador: _controllerTelefone,
              rotulo: 'Telefone',
              dica: '(11) 12345-6789',
            ),
            Editor(
              controlador: _controllerEmail,
              rotulo: 'E-mail',
              dica: 'exemplo@dominio.com',
            ),
            Editor(
              controlador: _controllerCpf,
              rotulo: 'CPF',
              dica: '123.456.789-00',
            ),
            ElevatedButton(
              onPressed: () {
                final String nome = _controllerNome.text;
                final String endereco = _controllerEndereco.text;
                final String telefone = _controllerTelefone.text;
                final String email = _controllerEmail.text;
                final String cpf = _controllerCpf.text;

                if (nome.isNotEmpty &&
                    telefone.isNotEmpty &&
                    email.isNotEmpty &&
                    cpf.isNotEmpty) {
                  final contatoCriado =
                      Contato(nome, endereco, telefone, email, cpf);
                  Navigator.pop(context, contatoCriado);
                }
              },
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}

//============== LISTA DE TRANSFERENCIAS =============================
class ListaTransferencias extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ListaTransferenciasState();
}

class _ListaTransferenciasState extends State<ListaTransferencias> {
  @override
  Widget build(BuildContext context) {
    final transferencias = AppData.of(context)!.transferencias;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Transferências'),
        backgroundColor: Colors.green,
      ),
      body: ListView.builder(
        itemCount: transferencias.length,
        itemBuilder: (context, indice) {
          final transferencia = transferencias[indice];
          return ItemTransferencia(transferencia);
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final Transferencia? transferenciaRecebida = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormularioTransferencia()),
          );

          if (transferenciaRecebida != null) {
            setState(() {
              transferencias.add(transferenciaRecebida);
            });
          }
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}

//============== FORMULARIO DE TRANSFERENCIAS =========================
class FormularioTransferencia extends StatelessWidget {
  final TextEditingController _controllerCampoNumeroConta =
      TextEditingController();
  final TextEditingController _controllerCampoValor = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nova Transferência'),
      ),
      body: Column(
        children: [
          Editor(
              controlador: _controllerCampoNumeroConta,
              rotulo: 'Número da Conta',
              dica: '0000'),
          Editor(
              controlador: _controllerCampoValor,
              rotulo: 'Valor',
              dica: '0.00'),
          ElevatedButton(
            onPressed: () {
              final int? numeroConta =
                  int.tryParse(_controllerCampoNumeroConta.text);
              final double? valor = double.tryParse(_controllerCampoValor.text);

              if (numeroConta != null && valor != null) {
                final transferenciaCriada = Transferencia(valor, numeroConta);
                Navigator.pop(context, transferenciaCriada);
              }
            },
            child: const Text('Confirmar'),
          )
        ],
      ),
    );
  }
}

//============== MODELOS DE DADOS ==================================
class Contato {
  final String nome;
  final String endereco;
  final String telefone;
  final String email;
  final String cpf;

  Contato(this.nome, this.endereco, this.telefone, this.email, this.cpf);
}

class Transferencia {
  final double valor;
  final int numeroConta;

  Transferencia(this.valor, this.numeroConta);
}

class ItemTransferencia extends StatelessWidget {
  final Transferencia _transferencia;

  const ItemTransferencia(this._transferencia);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: const Icon(Icons.monetization_on),
        title: Text('R\$ ${_transferencia.valor.toStringAsFixed(2)}'),
        subtitle: Text('Conta: ${_transferencia.numeroConta}'),
      ),
    );
  }
}

//============== COMPONENTE EDITOR =================================
class Editor extends StatelessWidget {
  final TextEditingController controlador;
  final String rotulo;
  final String dica;

  const Editor({
    required this.controlador,
    required this.rotulo,
    required this.dica,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        controller: controlador,
        style: const TextStyle(fontSize: 16.0),
        decoration: InputDecoration(
          labelText: rotulo,
          hintText: dica,
        ),
        keyboardType: TextInputType.text,
      ),
    );
  }
}
