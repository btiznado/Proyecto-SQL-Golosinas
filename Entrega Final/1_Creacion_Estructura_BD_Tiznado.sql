-- ==========================================================
-- PROYECTO FINAL: Distribuidora de Golosinas
-- AUTOR: Brayan Tiznado
-- SCRIPT 1: CREACIÓN DE ESTRUCTURA Y OBJETOS (DDL)
-- ==========================================================

DROP DATABASE IF EXISTS GoloDistribuidora;
CREATE DATABASE GoloDistribuidora;
USE GoloDistribuidora;

-- =====================
-- 1. CREACIÓN DE TABLAS 
-- =====================

-- 1. Tabla: CATEGORIAS
CREATE TABLE CATEGORIAS (
    id_categoria INT AUTO_INCREMENT,
    nombre_cat VARCHAR(50),
    PRIMARY KEY (id_categoria)
);

-- 2. Tabla: PROVEEDORES
CREATE TABLE PROVEEDORES (
    id_proveedor INT AUTO_INCREMENT,
    razon_social VARCHAR(100),
    telefono VARCHAR(30),
    PRIMARY KEY (id_proveedor)
);

-- 3. Tabla: ZONAS_ENTREGA
CREATE TABLE ZONAS_ENTREGA (
    id_zona INT AUTO_INCREMENT,
    nombre_zona VARCHAR(50),
    PRIMARY KEY (id_zona)
);

-- 4. Tabla: EMPLEADOS
CREATE TABLE EMPLEADOS (
    id_empleado INT AUTO_INCREMENT,
    nombre_completo VARCHAR(100),
    rol VARCHAR(50),
    PRIMARY KEY (id_empleado)
);

-- 5. Tabla: VEHICULOS
CREATE TABLE VEHICULOS (
    id_vehiculo INT AUTO_INCREMENT,
    patente VARCHAR(15) UNIQUE,
    modelo VARCHAR(50),
    PRIMARY KEY (id_vehiculo)
);

-- 6. Tabla: METODOS_PAGO
CREATE TABLE METODOS_PAGO (
    id_metodo INT AUTO_INCREMENT,
    descripcion VARCHAR(50),
    PRIMARY KEY (id_metodo)
);

-- 7. Tabla: PRODUCTOS
CREATE TABLE PRODUCTOS (
    id_producto INT AUTO_INCREMENT,
    nombre_prod VARCHAR(100),
    id_categoria INT,
    id_proveedor INT,
    precio_unitario DECIMAL(10,2),
    stock_actual INT DEFAULT 0,
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor)
);

-- 8. Tabla: CLIENTES
CREATE TABLE CLIENTES (
    id_cliente INT AUTO_INCREMENT,
    nombre_negocio VARCHAR(100),
    direccion VARCHAR(150),
    id_zona INT,
    dia_visita VARCHAR(20),
    PRIMARY KEY (id_cliente),
    FOREIGN KEY (id_zona) REFERENCES ZONAS_ENTREGA(id_zona)
);

-- 9. Tabla: PEDIDOS
CREATE TABLE PEDIDOS (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT,
    id_empleado INT,
    fecha_pedido DATE,
    estado VARCHAR(30) DEFAULT 'Pendiente',
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente),
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADOS(id_empleado)
);

-- 10. Tabla: DETALLE_PEDIDOS
CREATE TABLE DETALLE_PEDIDOS (
    id_detalle INT AUTO_INCREMENT,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto)
);

-- 11. Tabla: REMITOS
CREATE TABLE REMITOS (
    id_remito INT AUTO_INCREMENT,
    id_pedido INT,
    id_vehiculo INT, 
    fecha_entrega DATE,
    PRIMARY KEY (id_remito),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id_vehiculo)
);

-- 12. Tabla: FACTURAS
CREATE TABLE FACTURAS (
    id_factura INT AUTO_INCREMENT,
    id_pedido INT,
    id_metodo INT,
    fecha_emision DATE,
    total_facturado DECIMAL(12,2),
    PRIMARY KEY (id_factura),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (id_metodo) REFERENCES METODOS_PAGO(id_metodo)
);

-- 13. Tabla: COMPRAS_STOCK
CREATE TABLE COMPRAS_STOCK (
    id_compra INT AUTO_INCREMENT,
    id_proveedor INT,
    fecha_compra DATE,
    monto_total DECIMAL(12,2),
    PRIMARY KEY (id_compra),
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor)
);

-- 14. Tabla: GASTOS_LOGISTICA
CREATE TABLE GASTOS_LOGISTICA (
    id_gasto INT AUTO_INCREMENT,
    id_vehiculo INT,
    fecha_gasto DATE,
    concepto VARCHAR(100),
    monto DECIMAL(10,2),
    PRIMARY KEY (id_gasto),
    FOREIGN KEY (id_vehiculo) REFERENCES VEHICULOS(id_vehiculo)
);

-- 15. Tabla de Hechos: FACT_VENTAS
CREATE TABLE FACT_VENTAS (
    id_fact_venta INT AUTO_INCREMENT,
    fecha_venta DATE,
    id_cliente INT,
    id_producto INT,
    id_zona INT,
    id_empleado INT,
    cantidad_vendida INT,
    monto_total DECIMAL(12,2),
    PRIMARY KEY (id_fact_venta),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto),
    FOREIGN KEY (id_zona) REFERENCES ZONAS_ENTREGA(id_zona),
    FOREIGN KEY (id_empleado) REFERENCES EMPLEADOS(id_empleado)
);


-- ==========
-- 2. VISTAS 
-- ==========

-- Vista 1: Control de stock bajo
DROP VIEW IF EXISTS vw_productos_bajo_stock;
CREATE VIEW vw_productos_bajo_stock AS
SELECT p.id_producto, p.nombre_prod, p.stock_actual, pr.razon_social AS proveedor
FROM PRODUCTOS p
JOIN PROVEEDORES pr ON p.id_proveedor = pr.id_proveedor
WHERE p.stock_actual < 20;

-- Vista 2: Hoja de ruta logística
DROP VIEW IF EXISTS vw_pedidos_pendientes;
CREATE VIEW vw_pedidos_pendientes AS
SELECT pe.id_pedido, pe.fecha_pedido, c.nombre_negocio, c.direccion, pe.estado
FROM PEDIDOS pe
JOIN CLIENTES c ON pe.id_cliente = c.id_cliente
WHERE pe.estado IN ('Pendiente', 'Armado');

-- Vista 3: Ventas Históricas por Cliente
DROP VIEW IF EXISTS vw_ventas_por_cliente;
CREATE VIEW vw_ventas_por_cliente AS
SELECT c.nombre_negocio, SUM(f.monto_total) AS total_gastado, COUNT(f.id_fact_venta) AS cant_compras
FROM FACT_VENTAS f 
JOIN CLIENTES c ON f.id_cliente = c.id_cliente
GROUP BY c.nombre_negocio;

-- Vista 4: Ranking de Golosinas más vendidas (Volumen)
DROP VIEW IF EXISTS vw_ranking_golosinas;
CREATE VIEW vw_ranking_golosinas AS
SELECT p.nombre_prod, cat.nombre_cat, SUM(fv.cantidad_vendida) AS unidades_vendidas
FROM FACT_VENTAS fv 
JOIN PRODUCTOS p ON fv.id_producto = p.id_producto
JOIN CATEGORIAS cat ON p.id_categoria = cat.id_categoria
GROUP BY p.nombre_prod, cat.nombre_cat
ORDER BY unidades_vendidas DESC;

-- Vista 5: Facturación Mensual
DROP VIEW IF EXISTS vw_facturacion_mensual;
CREATE VIEW vw_facturacion_mensual AS
SELECT DATE_FORMAT(f.fecha_emision, '%Y-%m') AS mes, mp.descripcion AS metodo, SUM(f.total_facturado) AS ingreso_total
FROM FACTURAS f 
JOIN METODOS_PAGO mp ON f.id_metodo = mp.id_metodo
GROUP BY mes, metodo;


-- ============
-- 3. FUNCIONES 
-- ============
DELIMITER //

-- Función 1: Calcular el valor total de un pedido
DROP FUNCTION IF EXISTS fn_calcular_total_pedido //
CREATE FUNCTION fn_calcular_total_pedido (p_id_pedido INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_total DECIMAL(10,2);
    
    SELECT COALESCE(SUM(dp.cantidad * p.precio_unitario), 0)
    INTO v_total
    FROM DETALLE_PEDIDOS dp
    JOIN PRODUCTOS p ON dp.id_producto = p.id_producto
    WHERE dp.id_pedido = p_id_pedido;
    
    RETURN v_total;
END //

-- Función 2: Consultar stock disponible
DROP FUNCTION IF EXISTS fn_stock_disponible //
CREATE FUNCTION fn_stock_disponible (p_id_producto INT) 
RETURNS INT
READS SQL DATA
BEGIN
    DECLARE v_stock INT;
    
    SELECT stock_actual INTO v_stock
    FROM PRODUCTOS
    WHERE id_producto = p_id_producto;
    
    RETURN v_stock;
END //


-- ==================
-- 4. PROCEDIMIENTOS 
-- ==================

-- SP 1: Crear un nuevo pedido
DROP PROCEDURE IF EXISTS sp_crear_pedido //
CREATE PROCEDURE sp_crear_pedido(IN p_id_cliente INT, IN p_id_empleado INT, OUT p_id_pedido INT)
BEGIN
    INSERT INTO PEDIDOS (id_cliente, id_empleado, fecha_pedido, estado)
    VALUES (p_id_cliente, p_id_empleado, CURDATE(), 'Pendiente');

    SET p_id_pedido = LAST_INSERT_ID();
END //

-- SP 2: Actualizar el estado de un pedido
DROP PROCEDURE IF EXISTS sp_actualizar_estado_pedido //
CREATE PROCEDURE sp_actualizar_estado_pedido(IN p_id_pedido INT, IN p_nuevo_estado VARCHAR(30))
BEGIN
    UPDATE PEDIDOS
    SET estado = p_nuevo_estado
    WHERE id_pedido = p_id_pedido;
END //


-- ===========
-- 5. TRIGGERS 
-- ===========

-- Trigger 1: Restar stock
DROP TRIGGER IF EXISTS trg_restar_stock_post_detalle //
CREATE TRIGGER trg_restar_stock_post_detalle
AFTER INSERT ON DETALLE_PEDIDOS
FOR EACH ROW
BEGIN
    UPDATE PRODUCTOS
    SET stock_actual = stock_actual - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END //

-- Trigger 2: Generar remito automático
DROP TRIGGER IF EXISTS trg_generar_remito_post_entrega //
CREATE TRIGGER trg_generar_remito_post_entrega
AFTER UPDATE ON PEDIDOS
FOR EACH ROW
BEGIN
    IF NEW.estado = 'Entregado' AND OLD.estado != 'Entregado' THEN
        INSERT INTO REMITOS (id_pedido, fecha_entrega)
        VALUES (NEW.id_pedido, CURDATE());
    END IF;
END //

DELIMITER ;
