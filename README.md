# 🛍️ Aplicativo de Online Store em Flutter

Aplicativo de e-commerce desenvolvido em **Flutter**, com **backend em Firebase**, permitindo navegação fluida entre categorias, exibição detalhada de produtos, gerenciamento de carrinho e acompanhamento de pedidos em tempo real.

---

## 🚀 Funcionalidades Principais

### 🏠 Início
- Exibição de uma **grade de imagens promocionais**.
- Interface organizada e responsiva.

### 🛒 Produtos
- Exibição de **produtos por categoria**.
- Alternância entre visualização **em grade** ou **em lista**.
- Página detalhada do produto com:
  - Carrossel de imagens.
  - Tamanhos disponíveis.
  - Descrição e preço.
- Botão **“Adicionar ao carrinho”** habilitado ao selecionar o tamanho.
- Caso o usuário não esteja logado, exibe **“Entre para comprar”**.
- Página do carrinho:
  - Exibe todos os produtos adicionados.
  - Permite **alterar quantidades**.
  - Campo para **inserção de cupom de desconto**.
  - Seção de **cálculo de frete** (em desenvolvimento).
  - Exibe **subtotal, desconto, frete e total final**.
- Ao finalizar o pedido:
  - O carrinho é limpo automaticamente.
  - O pedido é exibido na aba **“Meus Pedidos”**.

### 📦 Meus Pedidos
- Lista todos os pedidos realizados com:
  - Código do pedido.
  - Descrição detalhada (quantidade e valor unitário).
  - Valor total.
- Atualização do **status do pedido em tempo real** via Firebase.

### 🏬 Lojas
- Exibição de **imagem, nome e endereço** das lojas.
- Opções de:
  - **Ligar diretamente** para a loja.
  - **Abrir no Google Maps** para visualizar a localização.

---

## 🔐 Autenticação
- Login e cadastro via **email e senha**.
- Funcionalidades de **carrinho** e **pedidos** disponíveis apenas para usuários autenticados.

---

## 🧩 Tecnologias e Dependências

| Plugin / Biblioteca | Função |
|----------------------|--------|
| **flutter_staggered_grid_view** | Exibição em grade na tela inicial |
| **cloud_firestore** | Acesso e gerenciamento do banco de dados Firebase |
| **carousel_slider** | Carrossel de imagens dos produtos |
| **transparent_image** | Carregamento suave de imagens |
| **scoped_model** | Gerenciamento de estado global do aplicativo |
| **firebase_auth** | Autenticação de usuários |
| **url_launcher** | Abertura de links externos (telefone e Google Maps) |
| **flutter_launcher_icons** | Icon para Android e iOS |

---

## ⚙️ Backend
- **Firebase Authentication** – controle de login e cadastro.  
- **Cloud Firestore** – armazenamento de produtos, pedidos e dados do usuário.

---

## 📱 Status do Projeto
- ✅ Versão Android: **completa e funcional**  
- 🚧 Versão iOS: **em fase de implementação**

---

## 💡 Próximos Passos
- Finalizar integração da versão iOS.
- Implementar cálculo de frete via API.
- Adicionar método de pagamento simulado.

---

## 👨‍💻 Autor
Desenvolvido por Alexandre Rebechi
💬 Entre em contato no [LinkedIn]( www.linkedin.com/in/alexandre-rebechi-b65106346 ) ou contribua com o projeto via pull request.

---

### 🏁 Licença
Este projeto é de uso livre para fins educacionais e demonstração técnica.
