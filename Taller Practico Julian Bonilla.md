# Taller Práctico Pragma: **Flutter & Patrones Avanzados** — **Safe-Vault Tracker App**

## Introducción

Este taller está diseñado para desarrolladores de nivel intermedio que buscan elevar la **calidad del código**, la **seguridad de los datos** y el **rendimiento** en aplicaciones empresariales de Flutter. Construiremos una aplicación móvil para el **rastreo de activos sensibles**, aplicando el patrón **Clean Architecture** y una variedad de **Patrones de Diseño GoF** (Creacionales, Estructurales y Comportamentales) para estructurar el código. Validaremos la funcionalidad con el desarrollo dirigido por comportamiento (**BDD/Gherkin**), protegeremos la información con **cifrado local**, y mejoraremos la respuesta de la UI con tareas pesadas en segundo plano a través de **Isolates**.

## Objetivo General (SMART)

Al finalizar el taller, el participante será capaz de diseñar, implementar y justificar una aplicación Flutter con una arquitectura modular, que aplique patrones GoF clave en sus capas, incorpore la suite de pruebas BDD con Gherkin, ejecute tareas de cifrado intensivas de manera asíncrona usando Isolates, y demuestre un código desacoplado y de alta calidad.

## Objetivos Específicos

  * Establecer una arquitectura modular robusta (e.g., Domain/Data/Presentation).
  * Aplicar el patrón **Factory** (Creacional) y **Adapter** (Estructural) en la capa de datos.
  * Implementar el patrón **Strategy** (Comportamental) para diferentes tipos de validación.
  * Configurar un *framework* BDD y escribir *Features* y *Steps* para validar comportamientos.
  * Implementar el cifrado/descifrado de datos y optimizar estas operaciones con **Isolates**.
  * Integrar y justificar el uso de cada patrón en el contexto de la aplicación.

## Arquitectura y Flujo de la App

La aplicación seguirá una estructura de capas (Clean Architecture) para separar las reglas de negocio (Domain) de las implementaciones externas (Data) y la interfaz (Presentation).

```ascii
+-------------------+
| Presentation/UI   | (Widgets, State Manager)
+--------+----------+
         | (Llama a Use Cases)
+--------v----------+
| Domain Layer      | (Entities, Use Cases, Repositories/Strategy Interfaces)
+--------+----------+
         | (Llama a Repositories Impl)
+--------v----------+
| Data Layer        | (Repository Impl, Data Sources - Local/Remote, ADAPTER)
+--------+----------+
         | (Operaciones E/S, Cifrado, ISOLATE Worker)
+--------v----------+
|  Local Storage /  |
|  External Crypto  |
+-------------------+
```

## Roadmap de Pasos

1.  **Paso 1:** Sentar las bases: Estructura, Entidades, y Patrón **Factory** (Creacional).
2.  **Paso 2:** Implementar el cifrado/descifrado y el patrón **Adapter** (Estructural).
3.  **Paso 3:** Optimizar el rendimiento con **Isolates** y el patrón **Strategy** (Comportamental).
4.  **Paso 4:** Configurar el *Testing* BDD/Gherkin y validar el flujo básico con las Estrategias.
5.  **Paso 5:** Conectar la Presentación (UI) y validar la integración completa.

-----

## Pasos detallados

### Paso 1: Sentar la Arquitectura, Entidades y Patrón Factory (Creacional)

  * **Objetivo del paso:** Establecer la estructura de carpetas `Domain`, `Data`, `Presentation` y definir las Entidades principales. Aplicar el patrón **Factory Method** para la creación de la Entidad `Asset`.

  * **Conexión con la app:** Se define el "qué" (el dominio), asegurando que la creación de las entidades sea controlada y consistente desde el inicio.

  * **Progresión del tema (básico → intermedio):**

      * Básico: Creación de la Entidad `Asset` inmutable y el *Use Case* de `CreateAsset`.
      * Intermedio: Implementación del **Factory Method** estático dentro de la Entidad o un *Factory* simple para centralizar la lógica de creación y validación inicial de `Asset`.

  * **Decisiones de diseño a tomar (elige y justifica):**

      * Opción A: **Constructor por defecto y validación externa.** | Opción B: **Factory Method** estático (`Asset.create(...)`) para encapsular la validación de negocio.
      * Recomendada: **Factory Method** para forzar un estado inicial válido de la Entidad y desacoplar la creación de la lógica de negocio (Patrón Creacional).

  * **Guía de implementación (sin solución completa):**

      * Definir la estructura de capas (`domain`, `data`, `presentation`).
      * Crear la Entidad `Asset` (`domain/entities/asset.dart`) con campos como `name`, `value`, `isEncrypted`, y el método estático `Asset.create`.
      * Definir la interfaz `AssetRepository` (`domain/repositories/asset_repository.dart`) y el *Use Case* `CreateAssetUseCase`.

    <!-- end list -->

    ```dart
    // domain/entities/asset.dart - Pseudocódigo de Factory Method
    class Asset {
      // ... campos finales
      factory Asset.create({required String name, required double value}) {
        if (name.isEmpty || value <= 0) {
          throw InvalidAssetException('Name or value are invalid.');
        }
        return Asset._(name: name, value: value, isEncrypted: false);
      }
      const Asset._({/* ... */});
    }
    ```

  * **Consultas sugeridas (docs oficiales/keywords):**

      * Búscalo como: “GoF Factory Method in Dart” o “Validating entities in Clean Architecture”.

  * **Preguntas catalizadoras (reflexión):**

      * “¿Qué ventaja ofrece el *Factory Method* sobre un constructor estándar cuando se trabaja con Entidades de Dominio inmutables que requieren validación inicial?”

  * **Checkpoint (lo que debes ver ahora):** Estructura de carpetas lista, Entidad `Asset` con *Factory Method*, `AssetRepository` (interfaz) y *Use Case* `CreateAssetUseCase` definidos.

  * **Retos (según nivel) con criterios de aceptación:**

      * Reto 1 (fácil): Crea la Entidad `EncryptedPayload` que será el DTO (Objeto de Transferencia de Datos) para guardar la data cifrada. **Criterio:** Solo contiene `cipherText` y `iv` (Vector de Inicialización).
      * Reto 2 (medio): Implementa una excepción personalizada (`InvalidAssetException`) que es capturada por el *Use Case* al intentar crear un `Asset` inválido. **Criterio:** El *Use Case* maneja la excepción del *Factory* y la propaga.

  * **Errores comunes (síntomas) & pistas:**

      * Síntoma: Tu Entidad `Asset` tiene un constructor que acepta todos los campos sin ninguna validación. | Pista: “revisa el principio de **Encapsulamiento del Dominio**; las reglas de negocio deben residir en la capa *Domain*.”

  * **Extensión opcional:** Haz que el `Asset` herede de `Equatable` para una comparación de igualdad más fácil.

### Paso 2: Implementar el cifrado/descifrado y el patrón Adapter (Estructural)

  * **Objetivo del paso:** Implementar la lógica de cifrado/descifrado y usar el patrón **Adapter** para aislar la dependencia de una librería externa.

  * **Conexión con la app:** La capa *Data* utiliza la implementación del `CryptoAdapter` para cifrar el *Asset* antes de persistirlo y descifrarlo al cargarlo, cumpliendo con la interfaz del `CryptoService` que requiere el *DataSource*.

  * **Progresión del tema (básico → intermedio):**

      * Básico: Seleccionar una librería de cifrado (e.g., `encrypt`) y cifrar/descifrar un *String*.
      * Intermedio: Crear una interfaz `CryptoService` (`domain/services/crypto_service.dart`) y la implementación **`EncryptAdapter`** (`data/adapters/encrypt_adapter.dart`) que adapta la API de la librería externa a la interfaz requerida por el *Domain*.

  * **Decisiones de diseño a tomar (elige y justifica):**

      * Opción A: **Llamar a la librería directamente** desde el *Data Source*. | Opción B: **Usar el patrón Adapter** para crear una capa de abstracción.
      * Recomendada: **Patrón Adapter** (Estructural) para que si en el futuro se cambia la librería de cifrado (e.g., de `encrypt` a otra), solo se modifica el `EncryptAdapter`, y no el *Data Source* ni el *Domain*.

  * **Guía de implementación (sin solución completa):**

      * Crear la interfaz `CryptoService` con métodos `encrypt(String)` y `decrypt(String)`.
      * Crear la clase `EncryptAdapter` que **implementa** `CryptoService` y **usa** la librería externa (e.g., `encrypt`).
      * Crear la `AssetLocalDataSource` que **depende** de la interfaz `CryptoService` (Inversión de Dependencias).
      * La `AssetRepositoryImpl` utilizará el *DataSource* para el mapeo *Entidad* $\leftrightarrow$ *Modelo*.

    <!-- end list -->

    ```dart
    // data/adapters/encrypt_adapter.dart (Adaptando la librería externa)
    class EncryptAdapter implements CryptoService {
      final Encrypter _encrypter; // De la librería 'encrypt'
      // ...
      @override
      String encrypt(String plainText) {
        // Implementación usando _encrypter.encrypt(...)
        return '...';
      }
      // ...
    }
    ```

  * **Consultas sugeridas (docs oficiales/keywords):**

      * Búscalo como: “Patrón Adapter en Dart/Flutter” o “Abstracción de librerías externas”.

  * **Preguntas catalizadoras (reflexión):**

      * “¿Cómo afecta el patrón *Adapter* a la mantenibilidad del código si la librería externa de cifrado sufre un cambio mayor en su API?”

  * **Checkpoint (lo que debes ver ahora):** La `AssetRepositoryImpl` llama a un *DataSource* que utiliza el `CryptoService` (que es el `EncryptAdapter`) para manejar el cifrado/descifrado, **todo de forma síncrona** aún.

  * **Retos (según nivel) con criterios de aceptación:**

      * Reto 1 (fácil): Asegura que el *DataSource* mapea correctamente entre la Entidad `Asset` (pura) y la `AssetModel` (con campos de DTO) usando `copyWith`. **Criterio:** El mapeo debe ser bidireccional y sin pérdida de datos.
      * Reto 2 (medio): Implementa la inyección de dependencias para `CryptoService` y `AssetLocalDataSource` usando `get_it` o similar. **Criterio:** La `AssetRepositoryImpl` no instancia a sus dependencias, sino que las resuelve.

  * **Errores comunes (síntomas) & pistas:**

      * Síntoma: El *Data Source* tiene `import` directos a la librería `encrypt`. | Pista: “revisa el patrón **Adapter** y el Principio de Inversión de Dependencias; el *Data Source* solo debe conocer la interfaz del *CryptoService*.”

### Paso 3: Optimizar con Isolates y el patrón Strategy (Comportamental)

  * **Objetivo del paso:** Trasladar la operación de cifrado a un **Isolate** y usar el patrón **Strategy** para manejar diferentes tipos de validación del `Asset`.

  * **Conexión con la app:** El **`EncryptAdapter`** (paso 2) se modifica para ejecutar la función de cifrado en un *Isolate*. El patrón **Strategy** se usa en el *Use Case* `CreateAssetUseCase` para permitir diferentes reglas de validación sin modificar el *Use Case*.

  * **Progresión del tema (básico → intermedio):**

      * Básico: Comprender el uso de `Isolate.run` para liberar el hilo de UI.
      * Intermedio: Crear una interfaz `ValidationStrategy` y diferentes implementaciones (e.g., `HighValueStrategy`, `LowValueStrategy`) que se inyectan en el *Use Case* al momento de la creación.

  * **Decisiones de diseño a tomar (elige y justifica):**

      * Opción A: **Lógica `if/else`** para la validación en el *Use Case*. | Opción B: **Patrón Strategy** (Comportamental) para desacoplar la regla de validación.
      * Recomendada: **Patrón Strategy** para que las reglas de validación (e.g., si el activo es de alto o bajo valor) puedan cambiarse o agregarse sin modificar el *Use Case* principal.

  * **Guía de implementación (sin solución completa):**

      * Modificar el `EncryptAdapter` para que el cifrado/descifrado se haga mediante `Isolate.run`.
      * Definir la interfaz `ValidationStrategy` (`domain/strategies/validation_strategy.dart`) con un método `validate(Asset)`.
      * Crear las implementaciones concretas (`HighValueStrategy`, `LowValueStrategy`).
      * Modificar `CreateAssetUseCase` para que reciba la estrategia adecuada por inyección y la ejecute antes de llamar al repositorio.

    <!-- end list -->

    ```dart
    // domain/strategies/validation_strategy.dart
    abstract class ValidationStrategy {
      void validate(Asset asset);
    }
    // domain/usecases/create_asset_usecase.dart (fragmento)
    class CreateAssetUseCase {
      final AssetRepository _repository;
      final ValidationStrategy _strategy; // Inyección
      // ...
      Future<void> execute(Asset asset) async {
        _strategy.validate(asset); // Ejecuta la estrategia
        await _repository.save(asset);
      }
    }
    ```

  * **Consultas sugeridas (docs oficiales/keywords):**

      * Búscalo como: “GoF Strategy Pattern Dart” o “Isolates for heavy crypto tasks in Flutter”.

  * **Preguntas catalizadoras (reflexión):**

      * “¿Qué ventaja de escalabilidad ofrece el *Strategy Pattern* si tu equipo de producto decide añadir 5 tipos más de activos, cada uno con una regla de validación diferente?”

  * **Checkpoint (lo que debes ver ahora):** La creación de un `Asset` pasa por la validación de la **Estrategia** inyectada y la operación de guardado ahora se ejecuta con el **Isolate Worker** (mediante el Adapter), liberando la UI.

  * **Retos (según nivel) con criterios de aceptación:**

      * Reto 1 (fácil): Implementa un `AssetFactory` que, basado en el valor del activo, **retorna la Estrategia** correcta para inyectarla al *Use Case*. **Criterio:** El *Use Case* recibe dinámicamente la estrategia correcta.
      * Reto 2 (medio): Crea un *Worker Isolate* de larga duración (en lugar de `Isolate.run` para cada tarea) en el `EncryptAdapter` para minimizar el *overhead* de la creación de *Isolates*. **Criterio:** El `SendPort/ReceivePort` se inicializa una sola vez y maneja múltiples peticiones.

  * **Errores comunes (síntomas) & pistas:**

      * Síntoma: La lógica de `HighValueStrategy` se mezcla con la de `LowValueStrategy`. | Pista: “revisa el principio de **Responsabilidad Única (SRP)**; cada estrategia debe enfocarse solo en su propia regla de validación.”

### Paso 4: Configurar BDD/Gherkin y validar el flujo con las Estrategias

  * **Objetivo del paso:** Configurar un *framework* BDD (`gherkin` o similar) y escribir *Features* para validar que el `CreateAssetUseCase` ejecuta la **Strategy** correcta basada en los datos de entrada.

  * **Conexión con la app:** Las pruebas BDD prueban el comportamiento del sistema: dado un *input*, se verifica que se activa el flujo del *Use Case* y la **Estrategia** esperada.

  * **Progresión del tema (básico → intermedio):**

      * Básico: Definición de los *Features* y *Scenarios* que cubren éxito/falla para cada tipo de estrategia.
      * Intermedio: Implementación de los *Step Definitions* usando **Mocks** (e.g., `mockito`) para **verificar que el método `validate` de la estrategia correcta fue llamado** (Verificación de Interacción).

  * **Decisiones de diseño a tomar (elige y justifica):**

      * Opción A: **Probar solo el resultado final** (Guardado/Error). | Opción B: **Probar la interacción** (Qué dependencias se usaron).
      * Recomendada: **Probar la interacción** para BDD de nivel intermedio, asegurando que el *Use Case* está orquestando correctamente la **Strategy** inyectada.

  * **Guía de implementación (sin solución completa):**

      * Escribir un `.feature` con dos escenarios: uno que debería disparar `HighValueStrategy` y otro `LowValueStrategy`.
      * En el *Step Definition*, usar *Mocks* para la **Repository** y para ambas **Strategy** implementaciones.
      * En el `Then`, usar `verify(mockStrategy.validate(any)).called(1)` para la estrategia esperada, y `verifyNever(...)` para la no esperada.

    <!-- end list -->

    ```gherkin
    Feature: Validaciones de Activos (Strategy)
      Scenario: Activo de Alto Valor requiere validación estricta
        Given que la HighValueStrategy está lista para validar
        When el usuario crea un activo con valor 50000.0
        Then la HighValueStrategy.validate es llamada
    ```

  * **Consultas sugeridas (docs oficiales/keywords):**

      * Búscalo como: “BDD Gherkin with Mockito verify interaction” o “Testing Clean Architecture Use Cases”.

  * **Preguntas catalizadoras (reflexión):**

      * “¿Cómo se asegura BDD que tu código cumple con los requisitos del negocio, incluso cuando las implementaciones internas (como el **Strategy**) cambian?”

  * **Checkpoint (lo que debes ver ahora):** Pruebas BDD que se ejecutan y validan que el `CreateAssetUseCase` selecciona y utiliza la `ValidationStrategy` correcta basándose en los datos.

  * **Retos (según nivel) con criterios de aceptación:**

      * Reto 1 (fácil): Añade un *Scenario* que verifica que si la **Estrategia** arroja una excepción, el *Use Case* no intenta guardar el activo en el repositorio. **Criterio:** `verifyNever(mockRepository.save(any))` debe pasar.
      * Reto 2 (medio): Crea un *Step Definition* reutilizable para inicializar el *Use Case* con la **Factory de Estrategias** (del Reto 1, Paso 3). **Criterio:** El *Setup* de las pruebas es más limpio y se enfoca en el comportamiento.

  * **Errores comunes (síntomas) & pistas:**

      * Síntoma: `verify(mockStrategy.validate(any))` falla porque el objeto *Mock* no fue inyectado al *Use Case*. | Pista: “revisa la configuración de tu **Inyector de Dependencias** en la capa de pruebas; debe usar los *Mocks* en lugar de las implementaciones concretas.”

### Paso 5: Conectar la Presentación (UI) y probar la integración completa

  * **Objetivo del paso:** Construir la UI simple y utilizar un gestor de estado para interactuar con los *Use Cases* y mostrar los resultados de la validación y la carga asíncrona.
  * **Conexión con la app:** La capa *Presentation* llama al *Domain* a través de los *Use Cases*. El cifrado asíncrono (**Isolate**) debe manifestarse como una UI responsiva, y las validaciones (**Strategy**) deben mostrar mensajes de error claros.
  * **Progresión del tema (básico → intermedio):**
      * Básico: Mostrar un *progress indicator* mientras el *Use Case* espera el resultado del cifrado (Isolate).
      * Intermedio: Utilizar un **State Manager** (e.g., `Provider`, `Bloc`) para manejar los estados **Loading/Success/Error** y mostrar *SnackBar* o *Dialogs* que comuniquen al usuario los errores provenientes de las **Strategies** (e.g., `InvalidAssetException`).
  * **Decisiones de diseño a tomar (elige y justifica):**
      * Opción A: **State Manager** simple (`ChangeNotifierProvider`). | Opción B: **State Manager** reactivo (`flutter_bloc` / `riverpod`).
      * Recomendada: **`Provider` o `Riverpod`** para mantener la sencillez del taller, pero asegurando que la vista solo reacciona a los cambios de estado (Principios de Responsabilidad Única y Open/Closed).
  * **Guía de implementación (sin solución completa):**
      * Crear la clase `AssetNotifier` que llama a `CreateAssetUseCase` y maneja su *Future* asíncrono.
      * Crear `AssetCreationScreen.dart` con un formulario y un botón.
      * El botón debe: 1. Mostrar `Loading`, 2. Llamar al *Use Case*, 3. Ocultar `Loading` y mostrar *Success* o *Error*.
      * Asegurarse de que las excepciones de `ValidationStrategy` se capturan y se muestran al usuario.
  * **Consultas sugeridas (docs oficiales/keywords):**
      * Búscalo como: “Managing loading states in Flutter Provider” o “Handling exceptions from Use Cases”.
  * **Preguntas catalizadoras (reflexión):**
      * “¿Cómo la UI puede diferenciar un error de la capa *Domain* (e.g., `InvalidAssetException` de la **Strategy**) de un error de la capa *Data* (e.g., `NetworkFailure`) para mostrar mensajes más específicos?”
  * **Checkpoint (lo que debes ver ahora):** Aplicación funcional. Al crear un activo, se muestra un *loader* (mientras el **Isolate** cifra) y se valida el *input* con la **Strategy** correcta. La lista de activos muestra los datos descifrados.
  * **Retos (según nivel) con criterios de aceptación:**
      * Reto 1 (fácil): Al cargar los activos, utiliza un patrón **Chain of Responsibility** simple en la UI para aplicar diferentes formatos (e.g., color del texto) basado en el valor del activo. **Criterio:** Los formatos se aplican mediante un patrón, no un `if/else` largo.
      * Reto 2 (medio): Implementa una prueba de widget para `AssetCreationScreen` que verifica que, al hacer clic en el botón con datos inválidos, se muestra un mensaje de error específico de la **Strategy**. **Criterio:** La prueba no depende de los *Use Cases* reales, sino de sus *Mocks*.
  * **Errores comunes (síntomas) & pistas:**
      * Síntoma: El *loader* de la UI no se muestra, o se muestra demasiado tiempo sin datos. | Pista: “revisa el uso de `notifyListeners()` en tu *Notifier* y asegúrate de que el estado de `isLoading` se actualiza **antes** y **después** de la llamada asíncrona al *Use Case*.”

-----

## Integración Final & Demo

El objetivo es demostrar que la aplicación no solo funciona, sino que está bien diseñada.

  * **Pasos de Ensamblaje:**

    1.  Asegurar la inyección de dependencias para enlazar el `AssetNotifier` (Presentation) con el *Use Case* (Domain), y el *Use Case* con el `AssetRepositoryImpl` (Data).
    2.  Verificar que el `EncryptAdapter` esté inyectado en el *DataSource*.
    3.  Asegurarse de que las **Strategies** se resuelven correctamente en la `AssetFactory`.

  * **Checklist de Demo:**

      * [ ] Creación exitosa de un activo de bajo valor.
      * [ ] Creación exitosa de un activo de alto valor (debe pasar por la **HighValueStrategy**).
      * [ ] Intento de crear un activo que **falla la validación** de la **Strategy** (mostrar error en UI).
      * [ ] Mostrar que la UI **no se congela** al hacer clic en guardar (demostrando el **Isolate Worker**).
      * [ ] Mostrar la lista de activos cargados (demostrando el **descifrado** al cargar).
      * [ ] Demostrar una prueba BDD que valida la interacción con una de las **Strategies**.

  * **Guion Corto de Demo:**
    *"Esta app es un rastreador seguro. Primero, intento guardar un activo de bajo valor. Observen cómo al presionar 'Guardar', el *loader* aparece brevemente sin bloquear la UI (gracias al **Isolate** en el cifrado). Ahora, intento guardar un activo de alto valor con datos inválidos; el **Strategy Pattern** evita el guardado y la UI muestra un mensaje de error claro. Finalmente, veamos la estructura; la capa *Data* usa un **Adapter** para aislar la librería de cifrado, y el *Domain* utiliza el patrón **Strategy** para manejar las validaciones de negocio."*

## Rúbrica de Evaluación (0–5)

| Criterio | Puntuación (5/5) |
| :--- | :--- |
| **Funcionalidad (App)** | Aplicación completa y funcional. Los datos se guardan y cargan, y el cifrado/descifrado es transparente al usuario. |
| **Calidad Técnica (Arquitectura y Patrones)** | Implementación correcta de **Clean Architecture**, **Factory**, **Adapter** y **Strategy**. Desacoplamiento total entre capas. |
| **Pruebas (BDD)** | Suite BDD configurada. Las pruebas validan el comportamiento de los *Use Cases* y verifican correctamente la **interacción** con las **Strategies** y **Mocks**. |
| **Performance (Isolates)** | El cifrado/descifrado se ejecuta completamente en **Isolates** o *Workers*, demostrando una UI responsiva al hacer la operación. |
| **UX y Gestión de Estado** | El estado de carga y los errores (especialmente los de la **Strategy**) se manejan profesionalmente con un gestor de estado, proporcionando *feedback* claro al usuario. |

## Material de Apoyo

1.  **Patrones GoF:**
      * **Documentación de Patrones GoF:** *Elegir una fuente fiable para la descripción de Factory, Adapter, y Strategy.*
2.  **Flutter Isolates:** Documentación oficial de Dart/Flutter sobre **Isolates** y `Isolate.run`.
3.  **Librería de Cifrado (`encrypt`):** Guía de uso de la librería `encrypt` para Flutter (AES/IV).
4.  **BDD con Gherkin:** Documentación del paquete `flutter_gherkin` o tutoriales de *Behaviour-Driven Development*.
5.  **Clean Architecture:** Un diagrama o artículo introductorio sobre la arquitectura de capas en aplicaciones móviles.

<!-- end list -->

  * **Glosario Breve:**
      * **Isolate:** Hilos de Dart que no comparten memoria (concurrencia).
      * **Gherkin:** Lenguaje de texto simple para describir el comportamiento del software (Given/When/Then).
      * **Adapter:** Patrón estructural para adaptar la interfaz de una clase a la interfaz que espera el cliente.
      * **Strategy:** Patrón comportamental que define una familia de algoritmos, los encapsula y los hace intercambiables.
      * **Factory Method:** Patrón creacional que proporciona una interfaz para crear objetos en una superclase, permitiendo a las subclases alterar el tipo de objeto que se creará.

-----