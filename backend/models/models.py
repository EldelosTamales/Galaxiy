# Database Models
# Estructura de clases para mapear tablas de la base de datos

# User Model - Usuarios (estudiantes y bibliotecarios)
# Fields: id, name, email, password, role, profile_data, created_at

# Book Model - Libros
# Fields: id, title, author_id, publisher_id, isbn, location, status, copies_total, copies_available, created_at

# Author Model - Autores
# Fields: id, name, biography, created_at

# Publisher Model - Editoriales
# Fields: id, name, country, created_at

# Loan Model - Préstamos
# Fields: id, user_id, book_id, loan_date, due_date, return_date, status, created_at

# Reserve Model - Reservas
# Fields: id, user_id, book_id, reserve_date, status, created_at

# Fine Model - Multas
# Fields: id, user_id, loan_id, amount, paid, paid_date, created_at

# Favorite Model - Favoritos
# Fields: id, user_id, book_id, created_at
