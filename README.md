===>ESPAÑOL

###############################
# Cómo Ejecutar la Aplicación #
###############################

Esta guía te ayudará a ejecutar tanto el servidor (NestJS) como el cliente (Flutter web) para esta aplicación.

Requisitos Previos
Node.js: Asegúrate de tener Node.js instalado (v14 o superior).
NestJS CLI: Instala el CLI de NestJS globalmente.


npm install -g @nestjs/cli
Flutter: Asegúrate de tener Flutter instalado (v2.0 o superior). Sigue la guía oficial de instalación de Flutter.
Ejecutando el Servidor

Navega al directorio del servidor:
cd ruta/a/tu/proyecto/server

Instala las dependencias:
npm install

Ejecuta el servidor:
npm run start
Servidor en ejecución: Por defecto, el servidor estará corriendo en http://localhost:4000.

Ejecutando el Cliente
Navega al directorio del cliente:
cd ruta/a/tu/proyecto/client

Instala las dependencias:
flutter pub get

Ejecuta la aplicación web de Flutter:
flutter run -d chrome
Cliente en ejecución: La aplicación web de Flutter debería abrirse en tu navegador web predeterminado.

Resumen
Servidor: http://localhost:4000
Cliente: Normalmente servido en http://localhost:8000 u otro puerto asignado por Flutter.
Notas Adicionales
Asegúrate de que el servidor esté en ejecución antes de iniciar el cliente para evitar problemas de conexión.
Actualiza la URL base en la aplicación de Flutter si la URL del servidor cambia.


===>ENGLISH

##############################
# How to Run the Application #
##############################

This guide will help you run both the server (NestJS) and the client (Flutter web) for this application.

Prerequisites
Node.js: Ensure you have Node.js installed (v14 or higher).
NestJS CLI: Install the NestJS CLI globally.


npm install -g @nestjs/cli
Flutter: Ensure you have Flutter installed (v2.0 or higher). Follow the official Flutter installation guide.
Running the Server

Navigate to the server directory:
cd path/to/your/project/server

Install the dependencies:
npm install

Run the server:
npm run start
Server is running: By default, the server will be running on http://localhost:4000.

Running the Client
Navigate to the client directory:
cd path/to/your/project/client

Install the dependencies:
flutter pub get

Run the Flutter web application:
flutter run -d chrome
Client is running: The Flutter web application should open in your default web browser.

Summary
Server: http://localhost:4000
Client: Typically served at http://localhost:8000 or another port assigned by Flutter.
Additional Notes
Ensure that the server is running before you start the client to avoid connection issues.
Update the base URL in the Flutter application if the server URL changes.
