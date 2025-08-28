📱 Magnum Bank - Teste Técnico (Posts App)

Este projeto foi desenvolvido como parte de um teste técnico Flutter, com foco em gerenciamento de estado utilizando BLoC, boas práticas de arquitetura e consumo de dados em páginação incremental (lazy loading).

🚀 Funcionalidades

Listagem de posts com scroll infinito (10 por vez).

Ação de atualizar post diretamente na tela de detalhe.

Tratamento de loading, erro e estado vazio com BLoC.

UI com design Glassmorphism (efeito de vidro suave).

Estrutura limpa e desacoplada.

🛠️ Tecnologias Utilizadas

Flutter

Dart

flutter_bloc
 - Gerenciamento de estado

equatable
 - Comparação de estados

http
 - Requisições REST

📂 Estrutura de Pastas
lib/
│
├── data/                # Camada de dados (datasources, repositories)
│   ├── datasources/
│   └── repositories/
│
├── domain/              # Camada de domínio (models, entidades, casos de uso)
│   ├── models/
│   └── usecases/
│
├── presentation/        # Camada de apresentação (UI + Bloc)
│   ├── home/
│   │   ├── bloc/        # PostsBloc, Events, States
│   │   └── pages/       # HomePage, PostDetailPage
│   └── widgets/         # Widgets reutilizáveis
│
└── main.dart            # EntryPoint do app

▶️ Como Rodar

Clone o repositório:

git clone https://github.com/seu-usuario/magnum-bank-teste.git


Acesse a pasta do projeto:

cd magnum-bank-teste


Instale as dependências:

flutter pub get


Rode o projeto:

flutter run

🧪 Testes

Os testes unitários foram escritos para garantir o comportamento correto do PostsBloc.
Para rodar os testes, utilize:

flutter test


Exemplo de cenários testados:

Carregar primeiros 10 posts.

Paginar para mais 10 posts.

Atualizar post com sucesso.

Lidar com erro ao buscar posts.

📸 Preview
<p align="center"> <img src="screenshot1.png" width="250"/> <img src="screenshot2.png" width="250"/> </p>
📌 Observações

Não foram adicionados limites no datasource nem no repository.

Toda a lógica de paginação foi implementada no Bloc, conforme solicitado.

👤 Autor

Seu Nome
🔗 LinkedIn : https://www.linkedin.com/in/cinthiasoudutra/
 | GitHub: https://github.com/cinthiadutra