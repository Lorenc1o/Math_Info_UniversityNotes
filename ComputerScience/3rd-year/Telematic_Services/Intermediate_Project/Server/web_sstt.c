#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <string.h>
#include <fcntl.h>
#include <signal.h>
#include <sys/types.h>
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#include <sys/select.h>
#include <sys/stat.h>
#include <time.h>
#include <linux/limits.h>
#include <regex.h>

#define VERSION 24
#define BUFSIZE 8192
#define ERROR 42
#define LOG 44
#define PROHIBIDO 403
#define NOENCONTRADO 404
#define TIMEOUT 30
#define MAXPET 10

struct
{
	char *ext;
	char *filetype;
} extensions[] = {
	{"gif", "image/gif"},
	{"jpg", "image/jpg"},
	{"jpeg", "image/jpeg"},
	{"png", "image/png"},
	{"ico", "image/ico"},
	{"zip", "image/zip"},
	{"gz", "image/gz"},
	{"tar", "image/tar"},
	{"txt", "text/html"},
	{"htm", "text/html"},
	{"html", "text/html"},
	{0, 0}};

char *errors[5]={
	"Bad Request",
	"Unauthorized",
	"Payment required",
	"Forbidden",
	"Not Found"
};

void debug(int log_message_type, char *message, char *additional_info, int socket_fd)
{
	int fd;
	char logbuffer[BUFSIZE * 2];

	switch (log_message_type)
	{
	case ERROR:
		(void)sprintf(logbuffer, "ERROR: %s:%s Errno=%d exiting pid=%d", message, additional_info, errno, getpid());
		break;
	case PROHIBIDO:
		// Enviar como respuesta 403 Forbidden
		(void)sprintf(logbuffer, "FORBIDDEN: %s:%s", message, additional_info);
		break;
	case NOENCONTRADO:
		// Enviar como respuesta 404 Not Found
		(void)sprintf(logbuffer, "NOT FOUND: %s:%s", message, additional_info);
		break;
	case LOG:
		(void)sprintf(logbuffer, " INFO: %s:%s:%d", message, additional_info, socket_fd);
		break;
	}

	if ((fd = open("webserver.log", O_CREAT | O_WRONLY | O_APPEND, 0644)) >= 0)
	{
		(void)write(fd, logbuffer, strlen(logbuffer));
		(void)write(fd, "\n", 1);
		(void)close(fd);
	}
	if (log_message_type == ERROR || log_message_type == NOENCONTRADO || log_message_type == PROHIBIDO)
		exit(3);
}

int max(int a, int b){
	if(a>=b) return a;
	return b;
}

int check_header(char header[BUFSIZE], int port){

	regex_t regex_line;
	char *reqline[3];
	reqline[0]=strtok(header, " \t");
	reqline[1] = strtok(NULL, " \t");
	reqline[2] = strtok(NULL, " \t\n");

	int must=1;
	for(int i=0;i<3;i++){
		if(reqline[i]==NULL || !strcmp(reqline[i]," "))
			must=0;
	}
	if(!must) return 0;

	if(strncmp(reqline[2], "HTTP/1.0", 8) != 0 && strncmp(reqline[2], "HTTP/1.1", 8) != 0){
		return 0;
	}

	char *line = strtok(NULL, "\r\n");
	//|([a-zA-Z][a-zA-Z0-9]*=..*)
	int match = regcomp(&regex_line, "([a-zA-Z][a-zA-Z0-9]*: ..*)", REG_EXTENDED);
	
	int hostexists=0;
	char *is_host=NULL;
	char host[30], ip[30];

	sprintf(host, "www.sstt6915.org:%d", port);
	sprintf(ip, "192.168.56.104:%d", port);

	while(line!=NULL){
		match = regexec(&regex_line, line, (size_t) 0, NULL, 0);
	
		if (match != 0) {
			regfree(&regex_line);
			return 0;
		}

		if(!hostexists && (((is_host=strstr(line, host))!=NULL) || ((is_host=strstr(line, ip))!=NULL))){
			hostexists=1;
		}		
		line = strtok(NULL, "\r\n");
	}
	regfree(&regex_line);
	return hostexists;
}

char* get_extension(char *contype){
	char *aux="";
	int i=0;
	while(strcmp(aux, contype) && i<11){
		aux = extensions[i].ext;
		i++;
	}
	if(strcmp(aux, contype)){
		return NULL;
	}
	return extensions[i-1].filetype;
}

int make_header(int code, char *codemsg, char *url, char *host, int conlength, char *contype, char buf[]){
	int n=sprintf(buf, "HTTP/1.1 %d %s\r\n", code, codemsg);
	n+=sprintf(buf+n, "Connection: Keep-Alive\r\n");

	if(host!=NULL){
		n+=sprintf(buf+n, "Host: %s\r\n", host);
	}
	
	n+=sprintf(buf+n, "Server: Ubuntu 16.04\r\n");

	if(url!=NULL){
	n+=sprintf(buf+n, "Content-Type: %s\r\n", contype);
	n+=sprintf(buf+n, "Content-Length: %d\r\n", conlength);
	}

	time_t date;
	time(&date);
	struct tm *local=localtime(&date);

	n+=sprintf(buf+n, "Date: %02d/%02d/%d %02d:%02d:%02d\r\n", local->tm_mday, local->tm_mon+1, local->tm_year+1900, local->tm_hour, local->tm_min, local->tm_sec);
	n+=sprintf(buf+n, "Keep-Alive: timeout=%d, max=%d\r\n\r\n", TIMEOUT, MAXPET);
	return n;
}

int send_file_from_url(int code, char *codemsg, char *url, char *host, int descriptorFichero)
{
	int fd, bytes_read, size, len;
	char send_buf[BUFSIZE];
	struct stat st;
	char *contype;
	char demanded_url[PATH_MAX];
	strcpy(demanded_url, url);
	strtok(url, ".");
	contype = strtok(NULL, ".");

	//
	//	Evaluar el tipo de fichero que se está solicitando, y actuar en
	//	consecuencia devolviendolo si se soporta u devolviendo el error correspondiente en otro caso
	//  Devuelvo un mensaje con código 400 Bad Request
	//  También puede ocurrir que se requiera un mensaje de este tipo desde otro lugar, por eso el 'or'
	//


	if (((contype = get_extension(contype))==NULL)){
		code = 415;
		codemsg = "Unsupported Media Type";
		contype = "text/html";
		strcpy(demanded_url, "/home/alumno/Practicas/errors/415_UnsMediaType.html");
	}
	else if(code == 400){
		code = 400;
		codemsg = "Bad Request";
		contype = "text/html";
		strcpy(demanded_url, "/home/alumno/Practicas/errors/400_BadRequest.html");
	}
	//
	//	En caso de que el fichero sea soportado, exista, etc. se envia el fichero con la cabecera
	//	correspondiente, y el envio del fichero se hace en blockes de un máximo de  8kB
	//
	if ((fd = open(demanded_url, O_RDONLY)) != -1) //El fichero existe a partir de nuestro directorio
	{
		fstat(fd,&st);
		size = st.st_size;
		// Aquí pedimos que se cree la cabecera correcta
		len = make_header(code, codemsg, url, host, size, contype, send_buf);

		//
		//Asumo que mi cabecera no ocupa 8kB, lo cual tiene sentido, pues mis cabeceras son cortas
		//y caben en send_buf[BUFSIZE]
		//

		write(descriptorFichero, send_buf, len);

		//Aquí vamos enviando el fichero como mucho en bloques de BUFSIZE=8kB
		while ((bytes_read = read(fd, send_buf, BUFSIZE)) > 0)
			write(descriptorFichero, send_buf, bytes_read);		
		return 1;
	}
	else
	{
		//Si todo es correcto, pero el fichero no existe a partir del directorio del servidor,
		//enviamos error 404 Not Found
		strcpy(demanded_url,"/home/alumno/Practicas/errors/404_NotFound.html");
		send_file_from_url(404, "Not Found", demanded_url, host, descriptorFichero);
		return 0;
	}
}

int leer(char buffer[BUFSIZE], char header[BUFSIZE], char body[BUFSIZE], int descriptorFichero){
	int bytes_leidos, bytes_acum=0; //tamaño leido en cada trama TCP, tamaño total
	int continue_reading=0; //si hay cuerpo, se activa esta variable
	int body_len=0; //si hay cuerpo, aquí guardo su tamaño
	while(((bytes_leidos = read(descriptorFichero, buffer+bytes_acum, BUFSIZE)) > 0) && !strstr(buffer+max(bytes_acum-3,0), "\r\n\r\n") && !continue_reading){
		bytes_acum+=bytes_leidos;
		char *con_len=NULL;
		//Si hay cuerpo, no paro en \r\n\r\n, si no cuando he leido todo
		if(!continue_reading && (con_len=strstr(buffer, "Content-Length: "))!=NULL){
			con_len += 16;
			char *endline=strstr(con_len, "\r\n");
			char cl[4];
			strncpy(cl, con_len, endline-con_len);
			continue_reading = body_len = atoi(cl);
		}
		if(continue_reading){
			continue_reading-=bytes_leidos;
		}
	}
	bytes_acum+=bytes_leidos; //Los últimos bytes leidos
	if (bytes_leidos < 0)
	{
		return(-1);
	}
	else if (bytes_leidos == 0)
	{
		return(0);
	}
	else
	{
		//
		// Si la lectura tiene datos válidos terminar el buffer con un \0
		//
		buffer[bytes_acum] = '\0';


		//Si el content_length entró en la última iteración, no lo compruebo dentro del while,
		//tengo que hacerlo fuera
		char *con_len=NULL;
		if(body_len == 0 && (con_len=strstr(buffer, "Content-Length: "))!=NULL){
			con_len += 16;
			char *endline=strstr(con_len, "\r\n");
			char cl[4];
			strncpy(cl, con_len, endline-con_len);
			body_len = atoi(cl);
		}

		char *header_ends = strstr(buffer, "\r\n\r\n");
		int head_len = header_ends-buffer;
		strncpy(header, buffer, head_len);
		if(body_len>0){
			strncpy(body, buffer+head_len+4, body_len);
		}
	}
}

void process_web_request(int descriptorFichero, int port)
{
	fd_set client;
	FD_ZERO(&client);
	FD_SET(descriptorFichero, &client);

	struct timeval timeout;
	timeout.tv_sec = TIMEOUT;
	timeout.tv_usec = 0;

	int maxpeticiones=MAXPET;

	while (select(descriptorFichero + 1, &client, NULL, NULL, &timeout))
	{
		debug(LOG, "request", "Ha llegado una peticion", descriptorFichero);
		//
		// Definir buffer y variables necesarias para leer las peticiones
		//
		char buffer[BUFSIZE] = {0}; //aquí guardaré el mensaje
		char header[BUFSIZE], body[BUFSIZE]; //aquí guardaré la cabecera y el cuerpo, resp.
		char *reqline[3]; //aquí guardaré los tres primeros campos de la cabecera
		int bytes_leidos; //total bytes leidos
		char *pwd = getenv("PWD"); //Directorio del servidor
		char demanded_url[PATH_MAX], rpath[PATH_MAX]; //url pedida y su resolución en el ordenador

		char host[FILENAME_MAX]; //nombre de host
		sprintf(host, "www.sstt6915.org:%d", port); //Así envío mi nombre de host

		bytes_leidos = leer(buffer, header, body, descriptorFichero); //Leo la petición

		if (bytes_leidos < 0)
		{
			debug(ERROR, "request", "Error de lectura", descriptorFichero);
			exit(-1);
		}
		else if (bytes_leidos == 0)
		{
			debug(ERROR, "request", "El cliente se desconectó inesperadamente", descriptorFichero);
			exit(-1);
		}
		else
		{
			debug(LOG, "request content", buffer, descriptorFichero);
			
			if(maxpeticiones--<=0){
				//Tratar el caso en que se excede el número máximo de peticiones (MEJORA)
				strcpy(demanded_url,"/home/alumno/Practicas/errors/429_TooManyRequests.html");
				send_file_from_url(429, "Too Many Requests", demanded_url, host, descriptorFichero);
				//Cierro la conexión por considerarlo un ataque a mi servidor
				break;
			}


			//
			//	TRATAR LOS CASOS DE LOS DIFERENTES METODOS QUE SE USAN
			//	(Se soporta solo GET)
			//

			char *start_line = strtok(buffer, "\r\n");
			reqline[0] = strtok(start_line, " \t");
			reqline[1] = strtok(NULL, " \t");
			reqline[2] = strtok(NULL, " \t");
			//
			//Comprobar que la cabecera presenta el formato FV
			//así como que se envía en las versiones HTTP soportadas
			//

			if(check_header(header, port)==0){
				strcpy(demanded_url, "/home/alumno/Practicas/errors/400_BadRequest.html");
				send_file_from_url(400, NULL, demanded_url, host, descriptorFichero);
			}
			else if (strncmp(reqline[0], "GET\0", 4) == 0) //Compruebo si es un GET
			{
				if (strncmp(reqline[1], "/\0", 2) == 0)
					reqline[1] = "/index.html"; //Si no se indica nada, devuelvo el index.html

				strcpy(demanded_url, pwd);

				strcat(demanded_url, reqline[1]);

				//
				//	Como se trata el caso de acceso ilegal a directorios superiores de la
				//	jerarquia de directorios
				//	del sistema
				//
				realpath(demanded_url, rpath);
				if (strstr(rpath, pwd) != NULL) 
				{
					send_file_from_url(200, "OK", rpath, host, descriptorFichero);
				}
				else
				{
					//Tratar el caso en que acceden a un directorio superior al mio
					strcpy(demanded_url,"/home/alumno/Practicas/errors/403_Forbidden.html");
					send_file_from_url(403, "Forbidden", demanded_url, host, descriptorFichero);
					//Cierro la conexión por considerarlo un ataque a mi servidor
					break;
				}
			
			}
			else if (strncmp(reqline[0], "POST\0", 5) == 0) //Compruebo si es un POST
			{
				char *email=NULL;
				if((email=strstr(body,"email=joseantonio.lorencioa\%40um.es"))!=NULL){
					strcpy(demanded_url, pwd);
					strcat(demanded_url, "/Privado/successful_login.html");
					send_file_from_url(200, "OK", demanded_url, host, descriptorFichero);			
				}
				else
				{
					strcpy(demanded_url, pwd);					
					strcat(demanded_url, "/login_gone_wrong.html");
					send_file_from_url(200, "OK", demanded_url, host, descriptorFichero);
				}
			}
			else{ //Si no es GET ni POST
				strcpy(demanded_url, "/home/alumno/Practicas/errors/400_BadRequest.html");
				send_file_from_url(400, NULL, demanded_url, host, descriptorFichero);	
			}

			timeout.tv_sec = 15;
			timeout.tv_usec = 0;
		}
	}
	close(descriptorFichero);
	exit(0);
}

int main(int argc, char **argv)
{
	int i, port, pid, listenfd, socketfd;
	socklen_t length;
	static struct sockaddr_in cli_addr;  // static = Inicializado con ceros
	static struct sockaddr_in serv_addr; // static = Inicializado con ceros

	//  Argumentos que se esperan:
	//
	//	argv[1]
	//	En el primer argumento del programa se espera el puerto en el que el servidor escuchara
	//
	//  argv[2]
	//  En el segundo argumento del programa se espera el directorio en el que se encuentran los ficheros del servidor
	//
	//  Verificar que los argumentos que se pasan al iniciar el programa son los esperados
	//

	//
	//  Verificar que el directorio escogido es apto. Que no es un directorio del sistema y que se tienen
	//  permisos para ser usado
	//

	if (chdir(argv[2]) == -1)
	{
		(void)printf("ERROR: No se puede cambiar de directorio %s\n", argv[2]);
		exit(4);
	}
	// Hacemos que el proceso sea un demonio sin hijos zombies
	if (fork() != 0)
		return 0; // El proceso padre devuelve un OK al shell

	(void)signal(SIGCHLD, SIG_IGN); // Ignoramos a los hijos
	(void)signal(SIGHUP, SIG_IGN);  // Ignoramos cuelgues

	debug(LOG, "web server starting...", argv[1], getpid());

	/* setup the network socket */
	if ((listenfd = socket(AF_INET, SOCK_STREAM, 0)) < 0)
		debug(ERROR, "system call", "socket", 0);

	port = atoi(argv[1]);

	if (port < 0 || port > 60000)
		debug(ERROR, "Puerto invalido, prueba un puerto de 1 a 60000", argv[1], 0);

	/*Se crea una estructura para la información IP y puerto donde escucha el servidor*/
	serv_addr.sin_family = AF_INET;
	serv_addr.sin_addr.s_addr = htonl(INADDR_ANY); /*Escucha en cualquier IP disponible*/
	serv_addr.sin_port = htons(port);			   /*... en el puerto port especificado como parámetro*/
	if (bind(listenfd, (struct sockaddr *)&serv_addr, sizeof(serv_addr)) < 0)
		debug(ERROR, "system call", "bind", 0);

	if (listen(listenfd, 64) < 0)
		debug(ERROR, "system call", "listen", 0);

	while (1)
	{
		length = sizeof(cli_addr);
		if ((socketfd = accept(listenfd, (struct sockaddr *)&cli_addr, &length)) < 0)
		{
			debug(ERROR, "system call", "accept", 0);
		}

		if ((pid = fork()) < 0)
		{
			debug(ERROR, "system call", "fork", 0);
		}
		else
		{
			if (pid == 0)
			{ // Proceso hijo
				(void)close(listenfd);
				process_web_request(socketfd, port); // El hijo termina tras llamar a esta función
				(void)close(socketfd);
			}
			else
			{ // Proceso padre
				(void)close(socketfd);
			}
		}
	}
}
