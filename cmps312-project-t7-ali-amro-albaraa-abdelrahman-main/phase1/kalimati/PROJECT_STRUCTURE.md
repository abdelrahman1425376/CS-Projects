lib/
├── core/
│ ├── data/
│ │ └── database/
│ │ ├── daos/
│ │ │ ├── word_dao.dart
│ │ │ ├── resource_dao.dart
│ │ │ ├── learning_package_dao.dart
│ │ │ └── user_dao.dart
│ │ └── app_database.dart
│ ├── navigations/
│ │ └── app_route.dart
│ ├── utils/
│ │ ├── constants.dart
│ │ ├── enums.dart ← ResourceTypeEnum, etc.
│ │ └── helpers.dart
│ └── widgets/
│ ├── app_button.dart
│ ├── app_input_field.dart
│ └── ...
│
├── features/
│ ├── auth/
│ │ ├── data/
│ │ │ └── repositories/
│ │ ├── domain/
│ │ │ ├── contract/
│ │ │ │ └── auth_repository.dart
│ │ │ └── entities/
│ │ │ └── user.dart
│ │ └── presentation/
│ │ ├── screens/
│ │ │ └── login_page.dart
│ │ └── widgets/
│ │ └── login_form.dart
│ │
│ ├── learning_packages/
│ │ ├── data/
│ │ │ ├── datasources/
│ │ │ │ └── learning_package_local_data_source.dart
│ │ │ └── repositories/
│ │ │ └── learning_package_repository_impl.dart
│ │ ├── domain/
│ │ │ ├── contract/
│ │ │ │ └── learning_package_repository.dart
│ │ │ └── entities/
│ │ │ ├── learning_package.dart
│ │ │ ├── word.dart
│ │ │ ├── definition.dart
│ │ │ ├── sentence.dart
│ │ │ └── resource.dart
│ │ └── presentation/
│ │ ├── screens/
│ │ │ ├── packages_list_page.dart
│ │ │ └── package_details_page.dart
│ │ └── widgets/
│ │ ├── word_card.dart
│ │ └── sentence_tile.dart
│ │
│ ├── game/
│ │ ├── data/
│ │ ├── domain/
│ │ └── presentation/
│ │ └── screens/
│ │ └── quiz_page.dart
│ │
│ └── teacher_tools/
│ ├── data/
│ ├── domain/
│ └── presentation/
│ └── screens/
│ └── create_package_page.dart
│
└── main.dart

# 🧩 Domain Model Explanation

This document describes the entities, attributes, and relationships for the learning package system, including relationship types (one-to-many, many-to-many, etc.).

---

## 🧱 1. ResourceTypeEnum

**Type:** Enumeration (Enum)

**Values:**

- `Photo`
- `Video`
- `Website`

**Purpose:**  
Used to classify what type of resource it is (like an image, video, or webpage).  
Referenced by the `Resource` class.

---

## 🗂 2. Resource

**Attributes:**

- `Extension: string` → the file extension (like `.jpg`, `.mp4`)
- `ResourceUrl: string` → the location of the resource (URL or path)
- `Title: string` → the name of the resource
- `Type: ResourceTypeEnum` → the type of resource (from the enum above)

**Relations:**

- `Word ↔ Resource`: **Many-to-many**
- `Sentence ↔ Resource`: **Many-to-many**

Each `Word` and each `Sentence` can have multiple related resources (e.g., images or videos).

---

## 📘 3. Definition

**Attributes:**

- `Text: string` → the actual definition of a word
- `Source: string` → where the definition came from (dictionary name or website)

**Relations:**

- `Word → Definition`: **One-to-many**  
  One `Word` can have multiple `Definitions`, but each `Definition` belongs to one `Word`.

---

## ✏️ 4. Sentence

**Attributes:**

- `Text: string` → the sentence text
- `Resources: List<Resource>` → multimedia related to the sentence (images, videos, etc.)

**Relations:**

- `Word → Sentence`: **One-to-many**  
  One `Word` can have multiple example `Sentences`, but each `Sentence` belongs to one `Word`.
- `Sentence ↔ Resource`: **Many-to-many**

---

## 🔤 5. Word

**Attributes:**

- `Text: string` → the word itself
- `Definitions: List<Definition>`
- `Sentences: List<Sentence>`
- `Resources: List<Resource>`

**Relations:**

- `LearningPackage → Word`: **One-to-many**  
  One `LearningPackage` can contain many `Words`, but each `Word` belongs to only one `LearningPackage`.
- `Word → Definition`: **One-to-many**
- `Word → Sentence`: **One-to-many**
- `Word ↔ Resource`: **Many-to-many**

---

## 🎓 6. LearningPackage

**Attributes:**

- `PackageId: string`
- `Author: string`
- `Category: string`
- `Description: string`
- `IconUrl: string`
- `Keywords: List<string>`
- `Language: string`
- `LastUpdatedDate: DateTime`
- `Level: string`
- `Title: string`
- `Version: string`
- `Words: List<Word>`

**Relations:**

- `User → LearningPackage`: **One-to-many**  
  One `User` can create many `LearningPackages`, but each `LearningPackage` belongs to one `User`.
- `LearningPackage → Word`: **One-to-many**

---

## 👤 7. User

**Attributes:**

- `Id: string`
- `Firstname: string`
- `Lastname: string`
- `Email: string`
- `Password: string`
- `Role: string`

**Relations:**

- `User → LearningPackage`: **One-to-many**  
  One `User` can create or manage multiple `LearningPackages`, but each `LearningPackage` belongs to one `User`.

---

## 🧠 Summary of Relationships

| From            | To              | Type         |
| --------------- | --------------- | ------------ |
| User            | LearningPackage | One-to-many  |
| LearningPackage | Word            | One-to-many  |
| Word            | Definition      | One-to-many  |
| Word            | Sentence        | One-to-many  |
| Word            | Resource        | Many-to-many |
| Sentence        | Resource        | Many-to-many |

---

✅ **Overall Summary:**
The system represents a hierarchy where **Users** own **LearningPackages**, each containing **Words**, which have **Definitions**, **Sentences**, and **Resources**.  
Resources can also be shared between **Words** and **Sentences**, creating **many-to-many** relationships for rich multimedia learning content.
