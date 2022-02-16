{
  "rules": [
    {
      "rulePriority": 1,
      "description": "Keep last ${keep_last_images_count} images.",
      "selection": {
        "tagStatus": "any",
        "countType": "imageCountMoreThan",
        "countNumber": ${keep_last_images_count}
      },
      "action": {
        "type": "expire"
      }
    }
  ]
}