-- ==========================================================
-- PROYECTO FINAL: Distribuidora de Golosinas
-- AUTOR: Brayan Tiznado
-- SCRIPT 2: INSERCIÓN DE DATOS PARA PRUEBAS (DML)
-- ==========================================================

USE GoloDistribuidora;

-- 1. Tablas
INSERT INTO CATEGORIAS (nombre_cat) VALUES 
('Alfajores'), ('Chocolates'), ('Caramelos y Chicles'), ('Galletitas'), ('Gomitas');

INSERT INTO PROVEEDORES (razon_social, telefono) VALUES 
('Arcor SA', '0800-333-1234'), ('Mondelez Argentina', '0800-444-5678'),
('Bagley', '0800-555-9012'), ('Georgalos', '0800-666-3456');

INSERT INTO ZONAS_ENTREGA (nombre_zona) VALUES 
('Zona Centro'), ('Zona Norte'), ('Zona Sur');

INSERT INTO EMPLEADOS (nombre_completo, rol) VALUES 
('Carlos Tevez', 'Preventista'), ('Juan Roman', 'Preventista'),
('Lionel Messi', 'Chofer'), ('Angel Di Maria', 'Chofer');

INSERT INTO VEHICULOS (patente, modelo) VALUES 
('AB123CD', 'Renault Kangoo'), ('EF456GH', 'Peugeot Partner');

INSERT INTO METODOS_PAGO (descripcion) VALUES 
('Efectivo'), ('Transferencia Bancaria'), ('MercadoPago');

-- 2. Productos y Clientes
INSERT INTO PRODUCTOS (nombre_prod, id_categoria, id_proveedor, precio_unitario, stock_actual) VALUES 
('Alfajor Blanco Triple (Caja x36)', 1, 1, 15000.00, 50),
('Alfajor Milka Mousse (Caja x24)', 1, 2, 18500.00, 15),
('Chocolate Block 170g', 2, 1, 3500.00, 100),
('Caramelos Flynn Paff (Bolsa 500g)', 3, 4, 4200.00, 10),
('Galletitas Chocolinas 250g', 4, 3, 1200.00, 200),
('Gomitas Mogul Ositos', 5, 1, 1800.00, 60);

INSERT INTO CLIENTES (nombre_negocio, direccion, id_zona, dia_visita) VALUES 
('Kiosco El Pelado', 'San Martin 450', 1, 'Lunes'),
('Almacen Doña Rosa', 'Belgrano 1200', 2, 'Martes'),
('MiniMercado Los Hermanos', 'Rivadavia 85', 3, 'Miércoles'),
('Kiosco 24hs Centro', 'Sarmiento 900', 1, 'Jueves');

-- 3. Pedidos, Remitos, Facturas
INSERT INTO PEDIDOS (id_cliente, id_empleado, fecha_pedido, estado) VALUES 
(1, 1, '2024-03-01', 'Entregado'),
(2, 2, '2024-03-15', 'Entregado'),
(3, 1, '2024-03-16', 'Pendiente'),
(4, 2, '2024-03-17', 'Armado');

INSERT INTO DETALLE_PEDIDOS (id_pedido, id_producto, cantidad) VALUES 
(1, 1, 2), (1, 3, 5),
(2, 5, 10), (2, 2, 1),
(3, 4, 3),
(4, 6, 2);

INSERT INTO REMITOS (id_pedido, id_vehiculo, fecha_entrega) VALUES 
(1, 1, '2024-03-02'), (2, 2, '2024-03-16');

INSERT INTO FACTURAS (id_pedido, id_metodo, fecha_emision, total_facturado) VALUES 
(1, 1, '2024-03-02', 47500.00), 
(2, 2, '2024-03-16', 30500.00);

INSERT INTO COMPRAS_STOCK (id_proveedor, fecha_compra, monto_total) VALUES 
(1, '2024-02-28', 150000.00), (2, '2024-03-10', 80000.00);

INSERT INTO GASTOS_LOGISTICA (id_vehiculo, fecha_gasto, concepto, monto) VALUES 
(1, '2024-03-02', 'Combustible', 15000.00),
(2, '2024-03-16', 'Peaje y Combustible', 18000.00);

-- 4. Fact Table
INSERT INTO FACT_VENTAS (fecha_venta, id_cliente, id_producto, id_zona, id_empleado, cantidad_vendida, monto_total) VALUES 
('2024-03-02', 1, 1, 1, 1, 2, 30000.00),
('2024-03-02', 1, 3, 1, 1, 5, 17500.00),
('2024-03-16', 2, 5, 2, 2, 10, 12000.00),
('2024-03-16', 2, 2, 2, 2, 1, 18500.00);
