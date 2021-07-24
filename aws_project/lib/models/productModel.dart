import 'dart:ffi';

class ProductModel {
  final int id;
  final String nome;
  final String descricao;
  final double preco;

  const ProductModel(this.id, this.nome, this.descricao, this.preco);
}
