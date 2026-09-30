class Pedido {
  int? id;
  String cliente;
  String prato;
  int quantidade;
  double valorUnitario;
  double total;
  String classificacao;
  String status;

  Pedido({
    this.id,
    required this.cliente,
    required this.prato,
    required this.quantidade,
    required this.valorUnitario,
    required this.total,
    required this.classificacao,
    required this.status,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'cliente': cliente,
      'prato': prato,
      'quantidade': quantidade,
      'valorUnitario': valorUnitario,
      'total': total,
      'classificacao': classificacao,
      'status': status,
    };
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      cliente: map['cliente'],
      prato: map['prato'],
      quantidade: map['quantidade'],
      valorUnitario: map['valorUnitario'],
      total: map['total'],
      classificacao: map['classificacao'],
      status: map['status'],
    );
  }
}
