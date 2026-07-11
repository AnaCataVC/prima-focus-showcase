# Semántica vs Métricas (Patrón UX)

## El Problema
La interfaz mostraba puntajes numéricos brutos para clasificar la importancia de las tareas (ej. `Score: 85.5`). Esto requiere un esfuerzo mental del usuario (carga cognitiva) para decodificar si ese puntaje es "bueno" o "malo", cuál es la escala máxima (¿es sobre 100? ¿es infinito?), y qué acción debe tomar.

## La Decisión
El cerebro humano procesa colores y etiquetas descriptivas mucho más rápido que los números abstractos. Reemplazamos los puntajes numéricos por *Badges* (etiquetas semánticas):
- Puntuación alta (> 70) = **"Urgente"** (Color Rojo)
- Puntuación media (40 - 70) = **"Alta"** (Color Azul)
- Puntuación baja (< 40) = **"Normal"** (Color Grisáceo/Neutro)

Esto agiliza la toma de decisiones, reduce la fricción y mejora la respuesta emocional del usuario frente a su lista de pendientes.
