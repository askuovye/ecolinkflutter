# EcoLink – Aplicativo de Pontos de Descarte Sustentável

## Descrição do Projeto
EcoLink é um aplicativo desenvolvido em Flutter que permite aos usuários visualizar locais de descarte de resíduos ao seu redor, utilizando colaboração comunitária para manter os pontos sempre atualizados. O objetivo é facilitar o descarte consciente, promover sustentabilidade e contribuir para a preservação do meio ambiente. Uma solução simples, acessível e com impacto direto na sua cidade.

---

## Tecnologias e Recursos Utilizados
- **Flutter** (Dart)
- **Firebase Authentication**
- **Firebase Firestore / Realtime Database**
- **Leaflet Maps** (via Flutter plugin)
- **REST API própria (Laravel)**
- **Arquitetura limpa organizada em camadas**
- **Gerenciamento de estado (Provider)**
- **Integração com geolocalização**

---

## Passos para Instalação e Execução

### 1. Clonar o Repositório
```bash
git clone https://github.com/askuovye/ecolinkflutter.git
cd ecolinkflutter
```

### 2. Instalar Dependências
```bash
flutter pub get
```

### 3. Configurações Adicionais
- Certifique-se de ter o **Flutter SDK** instalado e configurado.
- Configure o arquivo `google-services.json` (Android) e `GoogleService-Info.plist` (iOS), caso utilize Firebase.
- Verifique as permissões de localização no `AndroidManifest.xml` e no `Info.plist`.
- Conecte sua API Laravel aos endpoints utilizados pelo app.

### 4. Executar o Projeto
```bash
flutter run
```

---

## Usuário de Teste (se aplicável)
**Email:** test@ecolink.com<br>
**Senha:** 12345678

---

## Documentação da API
Este projeto integra diretamente com a API Laravel do EcoLink. A documentação completa da API — incluindo rotas, exemplos de requisição, estrutura de respostas e instruções de integração — foi gerada tomando como base todos os arquivos e arquiteturas fornecidos.

Acesse o arquivo **`DOCUMENTACAO_API.md`** para consultar:
- Como consumir as rotas da API
- Exemplos usando `fetch` e Flutter `http`
- Estrutura das requisições
- Boas práticas e organização

---

## Repositório Oficial
[GitHub – EcoLink Flutter](https://github.com/askuovye/ecolinkflutter)

