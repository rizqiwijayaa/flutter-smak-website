<?php

declare(strict_types=1);

$connection = new mysqli(
    getenv('SMAK_DB_HOST') ?: '127.0.0.1',
    getenv('SMAK_DB_USER') ?: 'root',
    getenv('SMAK_DB_PASSWORD') !== false ? getenv('SMAK_DB_PASSWORD') : '',
    getenv('SMAK_DB_NAME') ?: 'web_smak',
    (int) (getenv('SMAK_DB_PORT') ?: 3306)
);

if ($connection->connect_error) {
    http_response_code(500);
    header('Content-Type: application/json; charset=utf-8');
    echo json_encode([
        'success' => false,
        'message' => 'Koneksi database gagal.',
    ]);
    exit;
}

$connection->set_charset('utf8mb4');
