# Proyecto SQL - Coderhouse: Distribuidora de Golosinas

## Modelo de Negocio
Este proyecto diseña una base de datos para optimizar el flujo operativo de una distribuidora minorista, abarcando desde la compra hasta la logística de entrega.

* **Abastecimiento:** Se contacta a Proveedores mayoristas para reponer Productos clasificados por Categorías.
* **Gestión de Clientes:** Se mantiene una base de Clientes con sus respectivas direcciones y días de visita asignados.
* **Ciclo de Venta:**
    * Se genera un Pedido al visitar al cliente.
    * Se cargan los Detalles de Pedido (Cantidades y productos).
    * Se gestiona el cambio de estado a "Armado" una vez preparada la mercadería.
* **Despacho:** Se emite un Remito que acompaña la mercadería hasta la entrega efectiva.

## Diagrama Entidad-Relación (DER)
![Diagrama DER](./DER-%20Distribuidora%20golosinas%20-%20Tiznado%20Brayan.png)
> *Nota: También puedes acceder al archivo aquí:(https://drive.google.com/file/d/1MX-1KQRUhVScEovNFiTxIcRVCqek89dA/view?usp=sharing)*

## Estructura de Entrega
* **Entrega 1:** Script SQL y DER
* **Entrega 2:** Script de Inserción de Datos y Creación de Objetos de BD

## Herramientas Utilizadas
* **Motor de DB:** MySQL
* **Diseño:** Draw.io

## Objetos de la Base de Datos (Entrega 2)

👁️ Vistas (Views)

* vw_productos_bajo_stock: Muestra un listado de los productos cuyo stock actual es menor a 20 unidades, junto con su proveedor. Facilita la toma de decisiones de compra urgente.

* vw_pedidos_pendientes: Muestra los pedidos en estado 'Pendiente' o 'Armado' con los datos del cliente, sirviendo como hoja de ruta diaria.

⚙️ Funciones (Functions)

* fn_calcular_total_pedido: Recibe el ID de un pedido y calcula el valor monetario total sumando (cantidad * precio_unitario) de sus detalles.

* fn_stock_disponible: Devuelve el stock físico actual de un producto específico de manera rápida.

📦 Procedimientos Almacenados (Stored Procedures)

* sp_crear_pedido: Inserta automáticamente un nuevo registro en la tabla PEDIDOS con la fecha de hoy y el estado inicial 'Pendiente', agilizando la toma de pedidos.

* sp_actualizar_estado_pedido: Recibe el ID de un pedido y cambia su estado logístico (ej: de 'Armado' a 'Entregado').

⚡ Triggers (Disparadores)

* trg_restar_stock_post_detalle: Se dispara AFTER INSERT en DETALLE_PEDIDOS. Resta automáticamente la cantidad vendida del stock físico en la tabla de productos.

* trg_generar_remito_post_entrega: Se dispara AFTER UPDATE en PEDIDOS. Si el estado de un pedido cambia a 'Entregado', genera automáticamente el remito oficial correspondiente.
