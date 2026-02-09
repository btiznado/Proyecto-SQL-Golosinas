DROP DATABASE IF EXISTS GoloDistribuidora;
CREATE DATABASE GoloDistribuidora;
USE GoloDistribuidora;

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

-- 3. Tabla: PRODUCTOS
CREATE TABLE PRODUCTOS (
    id_producto INT AUTO_INCREMENT,
    nombre_prod VARCHAR(100),
    id_categoria INT,
    id_proveedor INT,
    precio_unitario DECIMAL(10,2),
    stock_actual INT,
    PRIMARY KEY (id_producto),
    FOREIGN KEY (id_categoria) REFERENCES CATEGORIAS(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES PROVEEDORES(id_proveedor)
);

-- 4. Tabla: CLIENTES
CREATE TABLE CLIENTES (
    id_cliente INT AUTO_INCREMENT,
    nombre_negocio VARCHAR(100),
    direccion VARCHAR(150),
    dia_visita VARCHAR(20),
    PRIMARY KEY (id_cliente)
);

-- 5. Tabla: PEDIDOS
CREATE TABLE PEDIDOS (
    id_pedido INT AUTO_INCREMENT,
    id_cliente INT,
    fecha_pedido DATE,
    estado VARCHAR(30),
    PRIMARY KEY (id_pedido),
    FOREIGN KEY (id_cliente) REFERENCES CLIENTES(id_cliente)
);

-- 6. Tabla: DETALLE_PEDIDOS
CREATE TABLE DETALLE_PEDIDOS (
    id_detalle INT AUTO_INCREMENT,
    id_pedido INT,
    id_producto INT,
    cantidad INT,
    PRIMARY KEY (id_detalle),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido),
    FOREIGN KEY (id_producto) REFERENCES PRODUCTOS(id_producto)
);

-- 7. Tabla: REMITOS
CREATE TABLE REMITOS (
    id_remito INT AUTO_INCREMENT,
    id_pedido INT,
    fecha_entrega DATE,
    PRIMARY KEY (id_remito),
    FOREIGN KEY (id_pedido) REFERENCES PEDIDOS(id_pedido)
);
