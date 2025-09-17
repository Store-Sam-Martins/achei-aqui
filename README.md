# 📍 AcheiAqui

Aplicativo iOS em SwiftUI para encontrar **supermercados, farmácias, shoppings, lanchonetes, restaurantes, bares e outros locais** em um raio de 25 km da **localização atual** do usuário ou a partir de um **CEP informado**.  

Exibe os locais em um **mapa interativo**, com opção de abrir **rotas no Apple Maps** (carro ou a pé).  

---

## 🚀 Tecnologias

- **Swift 5+**
- **SwiftUI**
- **MapKit**
- **CoreLocation**
- **Xcode 15+**
- iOS 17+ (recomendado)

---

## 📂 Estrutura do Projeto

```
📂 AcheiAqui
 ├── PlacesApp.swift              # Ponto de entrada
 ├── 📂 Managers
 │    └── LocationManager.swift   # Gerencia CoreLocation
 ├── 📂 Models
 │    └── PlaceType.swift         # Enum de categorias de locais
 ├── 📂 ViewModels
 │    └── SearchViewModel.swift   # Lógica de busca (CEP + Localização)
 └── 📂 Views
      ├── ContentView.swift       # Tela principal (mapa + controles)
      ├── ControlsBar.swift       # Campo de CEP + filtros + botões
      ├── LocateMeButton.swift    # Botão para centralizar no usuário
      └── PlaceDetailSheet.swift  # Sheet com detalhes do local
```

---

## ⚙️ Configuração do projeto no Xcode

### 1. Clonar ou criar projeto
- Crie um novo projeto no **Xcode** (App → SwiftUI → Swift).
- Copie os arquivos listados acima para dentro do seu projeto.

### 2. Configurar permissões de localização
Abra o arquivo **Info.plist** e adicione a chave:

```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Usamos sua localização para encontrar locais próximos (25 km).</string>
```

📌 Como fazer pelo Xcode (GUI):
1. Clique no **ícone azul do projeto** no Project Navigator.
2. Selecione o **Target** do app.
3. Vá até a aba **Info**.
4. Em **Custom iOS Target Properties**, clique no **+**.
5. Selecione **Privacy – Location When In Use Usage Description**.
6. No campo de valor, insira a mensagem acima.

---

## ▶️ Como rodar

1. Abra o projeto no **Xcode**.
2. Escolha um **simulador** ou **iPhone físico**.
3. Pressione **⌘R** para rodar.

> Na primeira execução, o iOS mostrará um alerta pedindo permissão de acesso à localização.  
> Clique em **Permitir** para o app funcionar corretamente.

---

## 🧪 Testes

### No simulador:
- Menu **Features > Location** para simular diferentes localizações (ex.: City Run, Freeway Drive, Custom Location).
- Teste buscas pelo botão **“Perto de mim”** ou digitando um **CEP válido**.

### Em dispositivo físico:
1. Conecte o iPhone via cabo USB ou Wi-Fi ao seu Mac.
2. No Xcode, selecione o **dispositivo físico** no menu de simuladores.
3. Vá em **Signing & Capabilities** e configure sua conta Apple ID (Free ou Developer Program pago).
4. Caso use conta gratuita:
   - Será necessário **reinstalar o app a cada 7 dias**.
   - Algumas permissões avançadas podem ter limitações.
5. Pressione **⌘R** para rodar no iPhone.
6. Quando aparecer o alerta de localização, toque em **Permitir**.

---

## 📌 Melhorias futuras
- Salvar **favoritos** usando SwiftData/CoreData.
- Histórico de **últimos CEPs pesquisados**.
- Aba de **lista de locais** ordenados por distância.
- Filtros dinâmicos para alterar o **raio de busca** (10 km, 25 km, 50 km).

---

## 👨‍💻 Autor
Desenvolvido por **Silvanei Martins**
