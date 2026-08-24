# 🏦 Fintech - Aplicación Móvil de Créditos Digitales

> **Solicita tu crédito desde cualquier lugar, en cualquier momento. Todo desde tu teléfono.**

---

## 📋 Descripción General

**Fintech** es una aplicación móvil desarrollada con Flutter que permite a los usuarios solicitar créditos virtuales de manera 100% digital, sin necesidad de visitar una agencia física. La app está diseñada exclusivamente para **clientes**, ofreciendo una experiencia fluida, segura y completamente desde el dispositivo móvil.

### 🎯 Propósito

- ✅ **100% Digital** - Sin papeleo ni filas
- ⚡ **Rápido** - Solicitud en menos de 5 minutos
- 🔒 **Seguro** - Datos encriptados y autenticación JWT
- 📱 **Mobile First** - Experiencia optimizada para teléfonos

---

## 🏗️ Arquitectura de la App

### Clean Architecture

```
lib/
├── config/          → Configuración (rutas, tema)
│   ├── routes/      → Sistema de navegación
│   └── theme/       → Estilos globales
│
├── core/            → Núcleo de la aplicación
│   ├── api/         → Cliente HTTP e interceptores
│   ├── constants/   → Constantes y variables de entorno
│   ├── storage/     → Almacenamiento local (SecureStorage, SharedPrefs)
│   └── utils/       → Utilidades (formatos, validadores)
│
├── data/            → Capa de datos
│   ├── models/      → Modelos de datos (Prestamo, Pago, Solicitud, etc.)
│   ├── providers/   → Proveedores de estado (Riverpod/Provider)
│   └── repositories/→ Repositorios (lógica de negocio)
│
└── presentation/    → Capa de presentación
    ├── navigation/  → Navegación (BottomNavBar)
    ├── screens/     → Pantallas de la app
    │   ├── auth/    → Login, Register, Forgot Password
    │   ├── home/    → Dashboard principal
    │   ├── pagos/   → Gestión de pagos y cuotas
    │   ├── perfil/  → Perfil de usuario
    │   ├── prestamos/→ Historial y detalle de préstamos
    │   └── solicitudes/→ Wizard de solicitud (6 pasos)
    └── widgets/     → Widgets reutilizables
        ├── badges/  → Badges de estado
        ├── cards/   → Tarjetas informativas
        └── common/  → Componentes comunes (botones, inputs, etc.)
```

---

## 🚀 Funcionalidades para Clientes

### 🔐 Autenticación

| Pantalla | Descripción |
|----------|-------------|
| **Login** | Inicio de sesión con email y contraseña |
| **Register** | Registro de nuevo usuario |
| **Forgot Password** | Recuperación de contraseña |

### 🏠 Dashboard (Home)

| Componente | Descripción |
|------------|-------------|
| **Header** | Saludo personalizado + notificaciones |
| **Quick Actions** | Accesos rápidos (Solicitar, Mis Préstamos, Pagar) |
| **Stats Section** | KPIs: préstamos activos, cuotas pendientes, total pagado |

### 📋 Mis Préstamos

| Pantalla | Descripción |
|----------|-------------|
| **Lista de Préstamos** | Historial de préstamos con filtros por estado |
| **Detalle del Préstamo** | Información completa del préstamo |
| **Cronograma de Cuotas** | Tabla detallada de cuotas (pendientes/pagadas) |
| **Progreso del Préstamo** | Barra de progreso de pago |

### 💳 Mis Pagos

| Pantalla | Descripción |
|----------|-------------|
| **Historial de Pagos** | Todos los pagos realizados |
| **Detalle de Pago** | Información del pago |
| **Detalle de Cuota** | Detalle de cuota específica |
| **Registrar Pago** | Formulario para pagar una cuota |

### 📝 Solicitar Crédito (Wizard 6 Pasos)

La solicitud de crédito se realiza mediante un asistente de 6 pasos:

| Paso | Descripción | Campos |
|------|-------------|--------|
| **1. Datos del Préstamo** | Configuración inicial | Monto, Plazo, Propósito |
| **2. Dirección** | Domicilio del usuario | Calle, Número, Colonia, Código Postal |
| **3. Información Laboral** | Datos del empleo | Empresa, Puesto, Ingresos, Antigüedad |
| **4. Datos Personales** | Información de contacto | Teléfono, Correo, Referencias |
| **5. Método de Pago** | Cuenta bancaria | Banco, Número de cuenta, CLABE |
| **6. Confirmación** | Resumen y envío | Verificación de datos |

✅ **Pantalla de Éxito** al finalizar la solicitud

### 👤 Mi Perfil

| Pantalla | Descripción |
|----------|-------------|
| **Ver Perfil** | Información personal del usuario |
| **Editar Perfil** | Modificación de datos personales |

---

## 📱 Pantallas Principales

```
📱 App Cliente
│
├── 🔐 Autenticación
│   ├── Login
│   ├── Register
│   └── Forgot Password
│
├── 🏠 Home
│   ├── Header (saludo + notificaciones)
│   ├── Quick Actions (4 botones rápidos)
│   └── Stats Section (KPIs)
│
├── 📋 Mis Préstamos
│   ├── Lista de préstamos
│   ├── Detalle del préstamo
│   ├── Cronograma de cuotas
│   └── Progreso de pago
│
├── 💳 Mis Pagos
│   ├── Historial de pagos
│   ├── Detalle de pago
│   ├── Detalle de cuota
│   └── Registrar pago
│
├── 📝 Solicitar Crédito
│   ├── Paso 1: Monto y Plazo
│   ├── Paso 2: Dirección
│   ├── Paso 3: Datos Laborales
│   ├── Paso 4: Datos Personales
│   ├── Paso 5: Método de Pago
│   ├── Paso 6: Confirmación
│   └── Éxito
│
└── 👤 Mi Perfil
    ├── Ver perfil
    └── Editar perfil
```

---

## 🛠️ Stack Tecnológico

### Frontend (Flutter)

```yaml
framework: Flutter 3.x
language: Dart
architecture: Clean Architecture
state_management: Provider / Riverpod
local_storage: 
  - flutter_secure_storage (JWT)
  - shared_preferences (preferencias)
http_client: http + interceptors
navigation: Rutas nombradas
platforms: 
  - Android
  - iOS
  - Web
  - Linux
  - macOS
  - Windows
```

### Comunicación con Backend

```
📱 App Móvil
    │
    ▼
🔌 API Client (http + interceptors)
    │
    ▼
📡 Backend (Node.js + Express)
    │
    ▼
🗄️ Base de Datos (PostgreSQL)
```

---

## 🔐 Seguridad

| Capa | Tecnología |
|------|------------|
| **Autenticación** | JWT (JSON Web Tokens) |
| **Almacenamiento** | `flutter_secure_storage` (encriptado) |
| **Comunicación** | HTTPS + Interceptores |
| **Validación** | Validators en frontend y backend |

---

## 🚦 Guía de Uso

### 📲 Instalación

```bash
# Clonar el repositorio
git clone https://github.com/tu-usuario/fintech-mobile.git

# Entrar al directorio
cd fintech-mobile

# Instalar dependencias
flutter pub get

# Ejecutar la app
flutter run

# Construir APK
flutter build apk --release

# Construir iOS
flutter build ios --release
```

### ⚙️ Variables de Entorno

Crear archivo `.env` en la raíz:

```env
API_URL=https://api.fintech.com
API_VERSION=v1
```

---

## 📱 Flujo del Usuario

```
1. 📲 Abre la app
         ↓
2. 🔐 Inicia sesión (Login)
         ↓
3. 🏠 Visualiza el Dashboard
         ↓
4. 📝 Solicita un crédito (Wizard 6 pasos)
         ↓
5. 📋 Revisa el estado de sus préstamos
         ↓
6. 💳 Realiza pagos de cuotas
         ↓
7. 👤 Gestiona su perfil
```

---

## 🎨 Temas

| Tema | Descripción |
|------|-------------|
| **Dark Mode** | Tema oscuro (por defecto) |
| **Light Mode** | Tema claro |
| **System** | Sigue preferencias del sistema |

---

## 📱 Navegación

La app utiliza **Bottom Navigation Bar** con 4 pestañas principales:

```
┌─────────────┐
│  🏠 Home    │  → Dashboard principal
├─────────────┤
│  📋 Préstamos│  → Historial de préstamos
├─────────────┤
│  💳 Pagos   │  → Historial de pagos
├─────────────┤
│  👤 Perfil  │  → Perfil de usuario
└─────────────┘
```

---

## 🏷️ Estados de Préstamos

| Estado | Descripción | Color |
|--------|-------------|-------|
| **Pendiente** | Solicitud en revisión | 🟡 Amarillo |
| **Aprobado** | Crédito aprobado | 🟢 Verde |
| **Rechazado** | Crédito rechazado | 🔴 Rojo |
| **Activo** | Crédito en curso | 🔵 Azul |
| **Pagado** | Crédito liquidado | 🟣 Morado |

---

## 🔧 Widgets Reutilizables

### Badges
- `estado_badge.dart` - Estado de préstamo
- `estado_cuota_badge.dart` - Estado de cuota
- `cuota_badge.dart` - Información de cuota

### Cards
- `prestamo_card.dart` - Tarjeta de préstamo
- `pago_card.dart` - Tarjeta de pago
- `solicitud_card.dart` - Tarjeta de solicitud
- `stat_card.dart` - Tarjeta de estadística

### Common
- `custom_button.dart` - Botón personalizado
- `custom_text_field.dart` - Campo de texto
- `empty_state.dart` - Estado vacío
- `error_widget.dart` - Error
- `loading_widget.dart` - Cargando
- `skeleton_loader.dart` - Skeleton loading

---

## 📦 Dependencias Principales

```yaml
dependencies:
  flutter:
    sdk: flutter
  
  # Networking
  http: ^1.1.0
  
  # State Management
  provider: ^6.0.0
  
  # Storage
  shared_preferences: ^2.2.0
  flutter_secure_storage: ^9.0.0
  
  # Environment
  flutter_dotenv: ^5.0.0
  
  # Utilities
  intl: ^0.18.0
  path_provider: ^2.0.0
```

---

## 🚀 Próximas Funcionalidades

| Funcionalidad | Estado |
|---------------|--------|
| Notificaciones Push | 🔜 Próximamente |
| Biometría (Huella/Face ID) | 🔜 Próximamente |
| Historial de Solicitudes | 🔜 Próximamente |
| Soporte en Vivo (Chat) | 🔜 Próximamente |
| Calculadora de Crédito | 🔜 Próximamente |

---
