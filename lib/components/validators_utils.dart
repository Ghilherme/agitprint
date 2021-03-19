class ValidatorUtils {
  /// Remover caracteres especiais (ex: `/`, `-`, `.`)
  static String removeCaracteres(String valor) {
    return valor.replaceAll(RegExp('[^0-9a-zA-Z]+'), '');
  }

  /// Remover o símbolo `R$`
  static String removerSimboloMoeda(String valor) {
    assert(valor.isNotEmpty);
    return valor.replaceAll('R\$ ', '');
  }

  /// Converter o valor de uma String com `R$`
  static double converterMoedaParaDouble(String valor) {
    assert(valor.isNotEmpty);
    final value = double.tryParse(
        valor.replaceAll('R\$ ', '').replaceAll('.', '').replaceAll(',', '.'));

    return value ?? 0;
  }

  /// Retornar o CPF utilizando a máscara: `XXX.YYY.ZZZ-NN`
  static String obterCpf(String cpf) {
    return cpf.length == 11
        ? '${cpf.substring(0, 3)}.${cpf.substring(3, 6)}.${cpf.substring(6, 9)}-${cpf.substring(9, 11)}'
        : cpf;
  }

  /// Retornar o CNPJ informado, utilizando a máscara: `XX.YYY.ZZZ/NNNN-SS`
  static String obterCnpj(String cnpj) {
    return cnpj.length == 14
        ? '${cnpj.substring(0, 2)}.${cnpj.substring(2, 5)}.${cnpj.substring(5, 8)}/${cnpj.substring(8, 12)}-${cnpj.substring(12, 14)}'
        : cnpj;
  }

  /// Retornar o CEP utilizando a máscara: `XX.YYY-ZZZ`
  static String obterCep(String cep, {bool ponto = true}) {
    return ponto
        ? '${cep.substring(0, 2)}.${cep.substring(2, 5)}-${cep.substring(5, 8)}'
        : '${cep.substring(0, 2)}${cep.substring(2, 5)}-${cep.substring(5, 8)}';
  }

  static String obterTelefone(String telefone, {bool ddd = true}) {
    if (telefone.length >= 10) {
      if (ddd) {
        return telefone.length == 10
            ? '(${telefone.substring(0, 2)}) ${telefone.substring(2, 6)}-${telefone.substring(6, 10)}'
            : '(${telefone.substring(0, 2)}) ${telefone.substring(2, 7)}-${telefone.substring(7, 11)}';
      } else {
        return (telefone.length == 8)
            ? '${telefone.substring(0, 4)}-${telefone.substring(4, 8)}'
            : '${telefone.substring(0, 5)}-${telefone.substring(5, 9)}';
      }
    } else
      return telefone;
  }

  static String extrairTelefone(String telefone, {bool ddd = true}) {
    if (telefone.length == 14 || telefone.length == 15) {
      if (ddd) {
        return telefone.length == 14
            ? '${telefone.substring(1, 3)}${telefone.substring(5, 9)}${telefone.substring(10, 14)}'
            : '${telefone.substring(1, 3)}${telefone.substring(5, 10)}${telefone.substring(11, 15)}';
      } else {
        return (telefone.length == 14)
            ? '${telefone.substring(5, 9)}${telefone.substring(10, 14)}'
            : '${telefone.substring(5, 10)}${telefone.substring(11, 15)}';
      }
    } else
      return telefone;
  }
}
