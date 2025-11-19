# a. Utiliser une image de base légère
FROM nginx:alpine

# b. Copier la page HTML dans Nginx
COPY index.html /usr/share/nginx/html/index.html

# c. Exposer le port 80
EXPOSE 80

# d. Commande de démarrage
CMD ["nginx", "-g", "daemon off;"]

