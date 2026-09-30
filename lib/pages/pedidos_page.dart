
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/pedido_viewmodel.dart';

class PedidosPage extends StatefulWidget {
  const PedidosPage({super.key});

  @override
  State<PedidosPage> createState() => _PedidosPageState();
}

class _PedidosPageState extends State<PedidosPage> {
  final clienteController = TextEditingController();
  final pratoController = TextEditingController();
  final quantidadeController = TextEditingController();
  final valorController = TextEditingController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<PedidoViewModel>().carregarPedidos();
    });
  }

  void cadastrarPedido() async {
    final cliente = clienteController.text;
    final prato = pratoController.text;
    final quantidade = int.tryParse(quantidadeController.text);
    final valor = double.tryParse(
      valorController.text.replaceAll(',', '.'),
    );

    if (cliente.isEmpty ||
        prato.isEmpty ||
        quantidade == null ||
        valor == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Preencha todos os campos corretamente.'),
        ),
      );
      return;
    }

    await context.read<PedidoViewModel>().adicionarPedido(
          cliente: cliente,
          prato: prato,
          quantidade: quantidade,
          valorUnitario: valor,
        );

    clienteController.clear();
    pratoController.clear();
    quantidadeController.clear();
    valorController.clear();

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pedido cadastrado com sucesso!'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pedidos - The Bear'),
      ),
      body: Consumer<PedidoViewModel>(
        builder: (context, viewModel, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: clienteController,
                  decoration: const InputDecoration(
                    labelText: 'Cliente',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: pratoController,
                  decoration: const InputDecoration(
                    labelText: 'Prato',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: quantidadeController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Quantidade',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: valorController,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  decoration: const InputDecoration(
                    labelText: 'Valor unitário',
                    prefixText: 'R\$ ',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cadastrarPedido,
                    child: const Text('Cadastrar Pedido'),
                  ),
                ),
                const SizedBox(height: 25),
                const Divider(),
                const SizedBox(height: 10),
                if (viewModel.carregando)
                  const CircularProgressIndicator()
                else if (viewModel.pedidos.isEmpty)
                  const Text('Nenhum pedido cadastrado.')
                else
                  ...viewModel.pedidos.map(
                    (pedido) => Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${pedido.cliente} | ${pedido.prato}',
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Quantidade: ${pedido.quantidade} | Total: R\$ ${pedido.total.toStringAsFixed(2).replaceAll('.', ',')}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Classificação: ${pedido.classificacao}',
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Status: ${pedido.status}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: pedido.status == 'Finalizado'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                if (pedido.status == 'Pendente')
                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        viewModel.finalizarPedido(
                                          pedido.id!,
                                        );
                                      },
                                      child: const Text('FINALIZAR'),
                                    ),
                                  ),
                                if (pedido.status == 'Pendente')
                                  const SizedBox(width: 8),
                                Expanded(
                                  child: OutlinedButton(
                                    onPressed: () {
                                      viewModel.excluirPedido(
                                        pedido.id!,
                                      );
                                    },
                                    child: const Text('EXCLUIR'),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
