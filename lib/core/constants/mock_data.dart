import '../../models/recipe.dart';

/// Local mock recipes for development.
///
/// This list will be replaced by Firestore data in a future milestone.
/// Images use Unsplash source URLs which are free for development use.
const List<Recipe> mockRecipes = [
  Recipe(
    name: 'Mexican Pizza',
    imageUrl:
        'https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?w=400&h=300&fit=crop',
    calories: 420,
    timeMinutes: 25,
    category: 'Lunch',
    rating: 4.7,
    reviewCount: 128,
  ),
  Recipe(
    name: 'French Toast',
    imageUrl:
        'https://images.unsplash.com/photo-1484723091739-30a097e8f929?w=400&h=300&fit=crop',
    calories: 310,
    timeMinutes: 15,
    category: 'Breakfast',
    rating: 4.5,
    reviewCount: 96,
  ),
  Recipe(
    name: 'Spicy Ramen Noodles',
    imageUrl:
        'https://images.unsplash.com/photo-1569718212165-3a8278d5f624?w=400&h=300&fit=crop',
    calories: 480,
    timeMinutes: 20,
    category: 'Dinner',
    rating: 4.8,
    reviewCount: 215,
  ),
  Recipe(
    name: 'Beef Steak',
    imageUrl:
        'https://images.unsplash.com/photo-1600891964092-4316c288032e?w=400&h=300&fit=crop',
    calories: 550,
    timeMinutes: 30,
    category: 'Dinner',
    rating: 4.9,
    reviewCount: 312,
  ),
  Recipe(
    name: 'Berry Pancakes',
    imageUrl:
        'https://images.unsplash.com/photo-1567620905732-2d1ec7ab7445?w=400&h=300&fit=crop',
    calories: 350,
    timeMinutes: 20,
    category: 'Breakfast',
    rating: 4.6,
    reviewCount: 87,
  ),
  Recipe(
    name: 'Caesar Salad',
    imageUrl:
        'https://images.unsplash.com/photo-1546793665-c74683f339c1?w=400&h=300&fit=crop',
    calories: 220,
    timeMinutes: 10,
    category: 'Lunch',
    rating: 4.3,
    reviewCount: 64,
  ),
  Recipe(
    name: 'Chocolate Lava Cake',
    imageUrl:
        'https://images.unsplash.com/photo-1606313564200-e75d5e30476c?w=400&h=300&fit=crop',
    calories: 390,
    timeMinutes: 35,
    category: 'Dessert',
    rating: 4.8,
    reviewCount: 174,
  ),
];
