-- ==========================================================
-- SCRIPT 1: INSERCIÓN DE DATOS
-- PROYECTO: Distribuidora de Golosinas
-- AUTOR: Brayan Tiznado
-- ==========================================================

USE GoloDistribuidora;

-- 1. Insertar Categorías
INSERT INTO CATEGORIAS (nombre_cat) VALUES 
('Alfajores'),
('Chocolates'),
('Caramelos y Chicles'),
('Galletitas'),
('Gomitas');

-- 2. Insertar Proveedores
INSERT INTO PROVEEDORES (razon_social, telefono) VALUES 
('Arcor SA', '0800-333-1234'),
('Mondelez Argentina', '0800-444-5678'),
('Bagley', '0800-555-9012'),
('Georgalos', '0800-666-3456');

-- 3. Insertar Productos
INSERT INTO PRODUCTOS (nombre_prod, id_categoria, id_proveedor, precio_unitario, stock_actual) VALUES 
('Alfajor Blanco Triple (Caja x36)', 1, 1, 15000.00, 50),
('Alfajor Milka Mousse (Caja x24)', 1, 2, 18500.00, 15),
('Chocolate Block 170g', 2, 1, 3500.00, 100),
('Caramelos Flynn Paff (Bolsa 500g)', 3, 4, 4200.00, 10),
('Galletitas Chocolinas 250g', 4, 3, 1200.00, 200),
('Gomitas Mogul Ositos', 5, 1, 1800.00, 60);

-- 4. Insertar Clientes
INSERT INTO CLIENTES (nombre_negocio, direccion, dia_visita) VALUES 
('Kiosco El Pelado', 'San Martin 450', 'Lunes'),
('Almacen Doña Rosa', 'Belgrano 1200', 'Martes'),
('MiniMercado Los Hermanos', 'Rivadavia 85', 'Miércoles'),
('Kiosco 24hs Centro', 'Sarmiento 900', 'Lunes');

-- 5. Insertar Pedidos
INSERT INTO PEDIDOS (id_cliente, fecha_pedido, estado) VALUES 
(1, '2024-03-01', 'Entregado'),
(2, '2024-03-15', 'Pendiente'),
(4, '2024-03-16', 'Pendiente');

-- 6. Insertar Detalles de los Pedidos
-- Pedido 1 (Kiosco El Pelado)
INSERT INTO DETALLE_PEDIDOS (id_pedido, id_producto, cantidad) VALUES 
(1, 1, 2),
(1, 3, 5);

-- Pedido 2 (Almacen Doña Rosa)
INSERT INTO DETALLE_PEDIDOS (id_pedido, id_producto, cantidad) VALUES 
(2, 5, 10),
(2, 2, 1);

-- Pedido 3 (Kiosco 24hs Centro)
INSERT INTO DETALLE_PEDIDOS (id_pedido, id_producto, cantidad) VALUES 
(3, 4, 3); -- 3 bolsas de Flynn Paff

-- 7. Insertar Remitos
INSERT INTO REMITOS (id_pedido, fecha_entrega) VALUES 
(1, '2024-03-02');