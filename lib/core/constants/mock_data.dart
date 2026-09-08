import '../../models/ingredient.dart';
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
    defaultServings: 2,
    ingredients: [
      Ingredient(name: 'Pizza Dough', quantity: '250g'),
      Ingredient(name: 'Tomato Sauce', quantity: '100ml'),
      Ingredient(name: 'Mozzarella', quantity: '150g'),
      Ingredient(name: 'Jalapeño', quantity: '2 pcs'),
      Ingredient(name: 'Black Beans', quantity: '80g'),
      Ingredient(name: 'Red Onion', quantity: '1/2 pc'),
    ],
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
    defaultServings: 2,
    ingredients: [
      Ingredient(name: 'Bread Slices', quantity: '4 pcs'),
      Ingredient(name: 'Eggs', quantity: '2 pcs'),
      Ingredient(name: 'Milk', quantity: '60ml'),
      Ingredient(name: 'Butter', quantity: '20g'),
      Ingredient(name: 'Cinnamon', quantity: '1 tsp'),
      Ingredient(name: 'Maple Syrup', quantity: '30ml'),
    ],
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
    defaultServings: 1,
    ingredients: [
      Ingredient(name: 'Ramen Noodles', quantity: '200g'),
      Ingredient(name: 'Chicken Broth', quantity: '500ml'),
      Ingredient(name: 'Soy Sauce', quantity: '2 tbsp'),
      Ingredient(name: 'Chili Paste', quantity: '1 tbsp'),
      Ingredient(name: 'Soft Boiled Egg', quantity: '1 pc'),
      Ingredient(name: 'Green Onion', quantity: '2 stalks'),
      Ingredient(name: 'Nori', quantity: '2 sheets'),
    ],
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
    defaultServings: 1,
    ingredients: [
      Ingredient(name: 'Ribeye Steak', quantity: '300g'),
      Ingredient(name: 'Olive Oil', quantity: '2 tbsp'),
      Ingredient(name: 'Garlic', quantity: '3 cloves'),
      Ingredient(name: 'Butter', quantity: '30g'),
      Ingredient(name: 'Rosemary', quantity: '2 sprigs'),
      Ingredient(name: 'Salt & Pepper', quantity: 'to taste'),
    ],
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
    defaultServings: 2,
    ingredients: [
      Ingredient(name: 'Flour', quantity: '150g'),
      Ingredient(name: 'Eggs', quantity: '2 pcs'),
      Ingredient(name: 'Milk', quantity: '200ml'),
      Ingredient(name: 'Mixed Berries', quantity: '120g'),
      Ingredient(name: 'Sugar', quantity: '2 tbsp'),
      Ingredient(name: 'Butter', quantity: '20g'),
    ],
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
    defaultServings: 2,
    ingredients: [
      Ingredient(name: 'Romaine Lettuce', quantity: '1 head'),
      Ingredient(name: 'Parmesan', quantity: '50g'),
      Ingredient(name: 'Croutons', quantity: '60g'),
      Ingredient(name: 'Caesar Dressing', quantity: '60ml'),
      Ingredient(name: 'Chicken Breast', quantity: '200g'),
      Ingredient(name: 'Lemon', quantity: '1/2 pc'),
    ],
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
    defaultServings: 2,
    ingredients: [
      Ingredient(name: 'Dark Chocolate', quantity: '150g'),
      Ingredient(name: 'Butter', quantity: '100g'),
      Ingredient(name: 'Eggs', quantity: '3 pcs'),
      Ingredient(name: 'Sugar', quantity: '80g'),
      Ingredient(name: 'Flour', quantity: '30g'),
      Ingredient(name: 'Vanilla Extract', quantity: '1 tsp'),
    ],
  ),
];
