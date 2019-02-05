La carpeta "nginx" se usa únicamente para cuando se corre la app localmente con docker-compose. Cuando se usa Kubernetes no se usa para nada la carpeta "nginx" ya que a cambio se hace uso de ingress-nginx (https://github.com/kubernetes/ingress-nginx) para el enrutamiento

Instrucciones uso:
- En la página web digitar el número que se desea (se sugiere números pequeños debido al cálculo que hace el componente "worker")
- Click "Submit"
- Refrescar la página

************** Instalación *****************
Para correrlo localmente con docker (Desarrollo):
  - docker-compose up
  - En el navegador abrir: localhost:3050

Para correrlo localmente en cluster k8s local (Desarrollo):
  - Verificar que las imagenes:
      alejotem11/multi-client
      alejotem11/multi-server
      alejotem11/multi-worker
    existan
  - Crear el objeto secret con la clave de la db postgres. La clave se puede cambiar sin problema en el siguiente comando:
    kubectl create secret generic pgpassword --from-literal PGPASSWORD=12345asdf
  - Install Ingress Nginx:
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/master/deploy/mandatory.yaml
    minikube addons enable ingress
  - ** TODO: Revisar por qué se origina el error 404 si no se realizan estos cambios en el local. En Google Cloud funciona el archivo original
    Editar el archivo ingress-service.yaml:
    - La anotación [nginx.ingress.kubernetes.io/rewrite-target: /$1] ajustarla a [nginx.ingress.kubernetes.io/rewrite-target: /]
    - Quitar la expresión ?(.*) de los paths

  - kubectl apply -f k8s
  - Abrir en el navegador la ip del cluster local (minikube ip)

Para desplegarlo en Google Cloud:
  - Seguir las instucciones del archivo deploy-to-GCP.txt