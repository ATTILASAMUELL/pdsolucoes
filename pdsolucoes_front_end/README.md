# PDSoluções - Front-end Flutter

Aplicação Flutter com Clean Architecture para Web e Mobile.

## 🚀 Executar

### Desenvolvimento
```bash
cd pdsolucoes_front_end
fvm flutter pub get
fvm flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

### Produção
```bash
fvm flutter run -d chrome --dart-define=API_BASE_URL=https://api.pdsolucoes.com --dart-define=PRODUCTION=true
```

### Opções de ambiente
- `API_BASE_URL` - URL da API (default: http://localhost:3000)
- `PRODUCTION` - Modo produção (default: false)

## 📁 Estrutura

```
lib/
├── core/                    # Núcleo
│   ├── constants/          # Cores, tipografia, endpoints
│   ├── theme/              # Tema
│   ├── network/            # Dio client
│   └── utils/
│
├── data/                   # Camada de Dados
│   ├── datasources/       # API calls
│   ├── models/            # DTOs
│   └── repositories/      # Implementações
│
├── domain/                # Camada de Domínio
│   ├── entities/         # Entidades
│   ├── repositories/     # Interfaces
│   └── usecases/         # Casos de uso
│
└── presentation/         # Camada de Apresentação
    ├── blocs/           # Estado (BLoC)
    ├── pages/           # Telas
    └── widgets/         # Componentes
```

## 🎨 Design System

### Cores
- Blue: `#4263EB`
- Purple: `#7048E8`
- Green: `#51CF66`
- Gray: `#212429`, `#495057`, `#ACB5BD`, `#DDE2E5`, `#F8F9FA`

### Tipografia
Fonte: Roboto (Google Fonts)

## 🔧 Componentes

### Botões
```dart
AppButton.primary(text: 'Salvar', onPressed: () {});
AppButton.secondary(text: 'Cancelar', onPressed: () {});
AppButton.alternate(text: 'Voltar', onPressed: () {});
```

### Inputs
```dart
AppTextField(label: 'Nome', controller: controller);
AppDateField(label: 'Data', onChanged: (date) {});
AppTextArea(label: 'Descrição', maxLines: 5);
```

### Alertas
```dart
AppAlert.success(context, 'Sucesso!');
AppAlert.error(context, 'Erro!');
AppAlert.warning(context, 'Atenção!');
```

## 🌐 API

### Configurar
Arquivo `.env`:
```env
API_BASE_URL=http://localhost:3000
```

### Endpoints
- Auth: `/auth/login`, `/auth/forgot-password`
- Employees: `/api/employees`
- Squads: `/api/squads`
- Reports: `/reports`

### Usar
```dart
context.read<AuthBloc>().add(
  LoginEvent(email: email, password: password),
);
```

## 📦 Dependências

- `flutter_bloc` - Estado
- `dio` - HTTP
- `google_fonts` - Tipografia
- `flutter_svg` - Logo
- `intl` - Datas

## 🔐 Login de Teste

```
Email: joao@example.com
Senha: senha123
```
