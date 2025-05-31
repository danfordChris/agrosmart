# Farm to Market API Documentation

## Base URL
```
http://localhost:8000/api/
```

## Authentication
The API uses session authentication. Users must be logged in to perform create, update, and delete operations.

### Authentication Headers
```
Authorization: Token your-auth-token
Content-Type: application/json
```

## API Endpoints

### Products API

#### List All Products
```
GET http://localhost:8000/api/products/
```
Query Parameters:
- `category`: Filter by category (e.g., ?category=vegetables)
- `min_price`: Minimum price filter (e.g., ?min_price=10)
- `max_price`: Maximum price filter (e.g., ?max_price=100)
- `growing_method`: Filter by growing method (e.g., ?growing_method=organic)
- `search`: Search in name and description (e.g., ?search=tomatoes)
- `ordering`: Sort results (e.g., ?ordering=-price, ?ordering=name)

Response:
```json
{
    "count": 100,
    "next": "http://localhost:8000/api/products/?page=2",
    "previous": null,
    "results": [
        {
            "id": 1,
            "name": "Fresh Tomatoes",
            "description": "Organic tomatoes from local farm",
            "price": "2.99",
            "quantity": 100,
            "category": "vegetables",
            "category_name": "Vegetables",
            "image": "http://localhost:8000/media/products/tomatoes.jpg",
            "seller": 1,
            "seller_name": "John Doe",
            "harvest_date": "2024-05-27",
            "farm_location": "Kigali, Rwanda",
            "growing_method": "organic",
            "created_at": "2024-05-27T10:00:00Z",
            "updated_at": "2024-05-27T10:00:00Z"
        }
    ]
}
```

#### Get Product Details
```
GET http://localhost:8000/api/products/{id}/
```
Response:
```json
{
    "id": 1,
    "name": "Fresh Tomatoes",
    "description": "Organic tomatoes from local farm",
    "price": "2.99",
    "quantity": 100,
    "category": "vegetables",
    "category_name": "Vegetables",
    "image": "http://localhost:8000/media/products/tomatoes.jpg",
    "seller": 1,
    "seller_name": "John Doe",
    "harvest_date": "2024-05-27",
    "farm_location": "Kigali, Rwanda",
    "growing_method": "organic",
    "created_at": "2024-05-27T10:00:00Z",
    "updated_at": "2024-05-27T10:00:00Z",
    "average_rating": 4.5,
    "total_reviews": 10
}
```

#### Create Product
```
POST http://localhost:8000/api/products/
```
Request Body:
```json
{
    "name": "Fresh Tomatoes",
    "description": "Organic tomatoes from local farm",
    "price": "2.99",
    "quantity": 100,
    "category": "vegetables",
    "harvest_date": "2024-05-27",
    "farm_location": "Kigali, Rwanda",
    "growing_method": "organic",
    "image": "base64_encoded_image_data"
}
```

Validation Rules:
- name: Required, max 100 characters
- description: Required, max 500 characters
- price: Required, positive decimal, max 2 decimal places
- quantity: Required, positive integer
- category: Required, must be one of valid categories
- harvest_date: Required, valid date
- farm_location: Required, max 200 characters
- growing_method: Required, must be one of valid methods
- image: Optional, max 5MB, supported formats: jpg, jpeg, png

#### Update Product
```
PUT http://localhost:8000/api/products/{id}/
```
Request Body:
```json
{
    "name": "Fresh Tomatoes",
    "description": "Updated description",
    "price": "3.99",
    "quantity": 50,
    "category": "vegetables",
    "harvest_date": "2024-05-27",
    "farm_location": "Kigali, Rwanda",
    "growing_method": "organic"
}
```

#### Delete Product
```
DELETE http://localhost:8000/api/products/{id}/
```

#### Get Seller Details
```
GET http://localhost:8000/api/products/{id}/seller_details/
```
Response:
```json
{
    "seller_name": "John Doe",
    "seller_email": "john@example.com",
    "seller_phone": "0712345678",
    "seller_address": "Kigali, Rwanda",
    "total_products": 15,
    "average_rating": 4.8,
    "member_since": "2024-01-01"
}
```

### Categories API

#### List All Categories
```
GET http://localhost:8000/api/categories/
```
Query Parameters:
- `search`: Search in name and description
- `ordering`: Sort results (e.g., ?ordering=name)

Response:
```json
{
    "count": 10,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "name": "Vegetables",
            "description": "Fresh vegetables from local farms",
            "created_at": "2024-05-27T10:00:00Z",
            "total_products": 50
        }
    ]
}
```

#### Get Category Details
```
GET http://localhost:8000/api/categories/{id}/
```
Response:
```json
{
    "id": 1,
    "name": "Vegetables",
    "description": "Fresh vegetables from local farms",
    "created_at": "2024-05-27T10:00:00Z",
    "total_products": 50,
    "products": [
        {
            "id": 1,
            "name": "Fresh Tomatoes",
            "price": "2.99",
            "image": "http://localhost:8000/media/products/tomatoes.jpg"
        }
    ]
}
```

#### Create Category
```
POST http://localhost:8000/api/categories/
```
Request Body:
```json
{
    "name": "Vegetables",
    "description": "Fresh vegetables from local farms"
}
```

Validation Rules:
- name: Required, max 50 characters, unique
- description: Required, max 200 characters

#### Update Category
```
PUT http://localhost:8000/api/categories/{id}/
```
Request Body:
```json
{
    "name": "Vegetables",
    "description": "Updated description"
}
```

#### Delete Category
```
DELETE http://localhost:8000/api/categories/{id}/
```

### Users API

#### Register User
```
POST http://localhost:8000/api/users/register/
```
Request Body:
```json
{
    "username": "johndoe",
    "email": "john@example.com",
    "password": "securepassword123",
    "first_name": "John",
    "last_name": "Doe",
    "phone_number": "0712345678",
    "address": "Kigali, Rwanda"
}
```

Validation Rules:
- username: Required, 3-30 characters, alphanumeric
- email: Required, valid email format, unique
- password: Required, min 8 characters, must contain uppercase, lowercase, number, special character
- first_name: Required, letters only, max 30 characters
- last_name: Required, letters only, max 30 characters
- phone_number: Required, must start with '06' or '07', 10 digits
- address: Required, max 200 characters

#### Login User
```
POST http://localhost:8000/api/users/login/
```
Request Body:
```json
{
    "username": "johndoe",
    "password": "securepassword123"
}
```
Response:
```json
{
    "token": "your-auth-token",
    "user": {
        "id": 1,
        "username": "johndoe",
        "email": "john@example.com",
        "first_name": "John",
        "last_name": "Doe"
    }
}
```

#### Get User Profile
```
GET http://localhost:8000/api/users/profile/
```
Response:
```json
{
    "id": 1,
    "username": "johndoe",
    "email": "john@example.com",
    "first_name": "John",
    "last_name": "Doe",
    "phone_number": "0712345678",
    "address": "Kigali, Rwanda",
    "date_joined": "2024-05-27T10:00:00Z",
    "total_orders": 5,
    "total_products": 10
}
```

#### Update User Profile
```
PUT http://localhost:8000/api/users/profile/
```
Request Body:
```json
{
    "first_name": "John",
    "last_name": "Doe",
    "phone_number": "0712345678",
    "address": "Kigali, Rwanda"
}
```

#### Change Password
```
POST http://localhost:8000/api/users/change-password/
```
Request Body:
```json
{
    "old_password": "currentpassword",
    "new_password": "newsecurepassword123"
}
```

### Orders API

#### List Orders
```
GET http://localhost:8000/api/orders/
```
Query Parameters:
- `status`: Filter by status (e.g., ?status=pending)
- `ordering`: Sort results (e.g., ?ordering=-created_at)

Response:
```json
{
    "count": 10,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "user": 1,
            "total_amount": "299.99",
            "status": "pending",
            "created_at": "2024-05-27T10:00:00Z",
            "updated_at": "2024-05-27T10:00:00Z"
        }
    ]
}
```

#### Create Order
```
POST http://localhost:8000/api/orders/
```
Request Body:
```json
{
    "items": [
        {
            "product": 1,
            "quantity": 2
        },
        {
            "product": 2,
            "quantity": 1
        }
    ],
    "shipping_address": "Kigali, Rwanda",
    "payment_method": "mobile_money"
}
```

Validation Rules:
- items: Required, non-empty array
- product: Required, must exist
- quantity: Required, positive integer, must be available
- shipping_address: Required, max 200 characters
- payment_method: Required, must be one of: mobile_money, cash, bank_transfer

#### Get Order Details
```
GET http://localhost:8000/api/orders/{id}/
```
Response:
```json
{
    "id": 1,
    "user": 1,
    "total_amount": "299.99",
    "status": "pending",
    "created_at": "2024-05-27T10:00:00Z",
    "updated_at": "2024-05-27T10:00:00Z",
    "items": [
        {
            "product": {
                "id": 1,
                "name": "Fresh Tomatoes",
                "price": "2.99"
            },
            "quantity": 2,
            "subtotal": "5.98"
        }
    ],
    "shipping_address": "Kigali, Rwanda",
    "payment_method": "mobile_money",
    "payment_status": "pending"
}
```

#### Cancel Order
```
POST http://localhost:8000/api/orders/{id}/cancel/
```
Request Body:
```json
{
    "reason": "Customer request"
}
```

### Reviews API

#### List Product Reviews
```
GET http://localhost:8000/api/products/{id}/reviews/
```
Query Parameters:
- `rating`: Filter by rating (e.g., ?rating=5)
- `ordering`: Sort results (e.g., ?ordering=-created_at)

Response:
```json
{
    "count": 5,
    "next": null,
    "previous": null,
    "results": [
        {
            "id": 1,
            "product": 1,
            "customer": 1,
            "customer_name": "John Doe",
            "rating": 5,
            "comment": "Excellent quality!",
            "created_at": "2024-05-27T10:00:00Z"
        }
    ]
}
```

#### Create Review
```
POST http://localhost:8000/api/products/{id}/reviews/
```
Request Body:
```json
{
    "rating": 5,
    "comment": "Excellent quality!"
}
```

Validation Rules:
- rating: Required, integer between 1 and 5
- comment: Required, max 500 characters
- User must have purchased the product
- User can only review once per product

## Error Responses

### 400 Bad Request
```json
{
    "field_name": [
        "Error message"
    ]
}
```

### 401 Unauthorized
```json
{
    "detail": "Authentication credentials were not provided."
}
```

### 403 Forbidden
```json
{
    "detail": "You do not have permission to perform this action."
}
```

### 404 Not Found
```json
{
    "detail": "Not found."
}
```

### 429 Too Many Requests
```json
{
    "detail": "Request was throttled. Expected available in 60 seconds."
}
```

## Rate Limiting
- 100 requests per minute for authenticated users
- 20 requests per minute for unauthenticated users

## Notes
- All timestamps are in UTC
- Images are served from the /media/ directory
- Pagination is set to 10 items per page
- All prices are in decimal format with 2 decimal places
- Category choices: vegetables, fruits, dairy, meat, grains, other
- Growing method choices: organic, conventional, hydroponic, greenhouse
- Phone numbers must start with '06' or '07' and be 10 digits long
- All dates should be in YYYY-MM-DD format
- Authentication is required for all POST, PUT, and DELETE requests
- Only product owners can update or delete their products
- Only order owners can view their orders
- Only authenticated users can create reviews
- Users can only review a product once
- All API responses are in JSON format
- Maximum file upload size is 5MB
- Supported image formats: jpg, jpeg, png
- API versioning is handled through URL (e.g., /api/v1/)
- All monetary values are in Rwandan Francs (RWF)
- Orders can be cancelled within 24 hours of creation
- Reviews can be edited within 7 days of creation
- Product images are automatically resized to 800x600 pixels
- All text fields are sanitized to prevent XSS attacks
- API keys are required for third-party integrations
- Webhook notifications are available for order status changes
- Bulk operations are limited to 100 items per request
- Search queries are limited to 100 characters
- All passwords are hashed using bcrypt
- Session tokens expire after 24 hours
- Failed login attempts are limited to 5 per hour
- All API endpoints support CORS
- API documentation is available at /api/docs/
- Health check endpoint is available at /api/health/