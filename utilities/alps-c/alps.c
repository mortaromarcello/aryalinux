#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define SCRIPTS_DIR "/var/cache/alps/scripts/"
#define INSTALLED_LIST "/etc/alps/installed-list"

char** dependencies;
int dependencyCount = 0;

char** processed;
int processedCount = 0;

int force = 0;

void init()
{
	int i;
	dependencies = (char**) malloc(sizeof(char*) * 1024);
	processed = (char**) malloc(sizeof(char*) * 1024);
}

int isInstalled(char* package)
{
	FILE* file = fopen(INSTALLED_LIST, "r");
	char line[128];
	fgets(line, 128, file);
	char* str = (char*)malloc(strlen(package) * sizeof(char) + 2);
	strcpy(str, "");
	strcat(str, package);
	strcat(str, "=>");
	//printf("%s\n", str);
	while (line != NULL && !feof(file))
	{
		char* temp = strstr(line, str);
		// This means that the word is found
		// Need to check if the word is found in the beginning
		// If the word is found in the beginning, the length of the line
		// And the length of temp would be same..
		if (temp != NULL && strlen(temp) == strlen(line))
		{
			fclose(file);
			return 1;
		}
		fgets(line, 128, file);
	}
	fclose(file);
	return 0;
}

int isProcessed(char* package)
{
	int i = 0;
	/*if (package != NULL)
	{
		printf("Package : %s\n", package);
	}
	else
	{
		printf("Package name error\n");
	}*/
	//printf("Checking processed status for %s...", package);
	while(processed[i] != NULL)
	{
		//printf("Inside\n");
		if (strcmp(processed[i++], package) == 0)
		{
			//printf(" Yes\n");
			return 1;
		}
	}
	//printf(" No\n");
	return 0;
}

void listAsDependency(char* package)
{
	int i = 0;
	//printf("asasa %d", i);
	//exit(0);
	while(dependencies[i] != NULL)
	{
		if (strcmp(dependencies[i], package) == 0)
		{
			return;
		}
		i++;
	}
	dependencies[dependencyCount++] = package;
	//printf("Deps collected : %d\n", dependencyCount);
}

void listAsProcessed(char* package)
{
	int i;
	while(processed[i] != NULL)
	{
		if (strcmp(processed[i], package) == 0)
		{
			return;
		}
	}
	processed[processedCount++] = package;
}

FILE* readScript(char* package)
{
	char fileName[128];
	strcpy(fileName, "");
	strcat(fileName, SCRIPTS_DIR);
	strcat(fileName, package);
	strcat(fileName, ".sh");
	//printf("Opening %s\n", fileName);
	FILE* file = fopen(fileName, "r");
	if (file == NULL)
	{
		printf("Script for %s not found. Aborting.\n\n", package);
		exit(1);
	}
	return file;
}

char** findDependencies(FILE* file)
{
	char* buffer;
	char** deps = (char**) malloc(sizeof(char*) * 1000);
	int count = 0;
	int i;
	long length;
	char* line;
	fseek(file, 0, SEEK_END);
	length = ftell(file);
	buffer = (char*) malloc((sizeof(char) * length) + 1);
	rewind(file);
	fread(buffer, length, 1, file);
	buffer[length] = '\0';
	line = strtok(buffer, "\n");
	while(line != NULL)
	{
		//printf("%s\n", line);
		//printf(line);
		char* found = strstr(line, "#DEP:");
		//printf("++%s\n", found);
		//printf("????%s\n", line+5);
		if (found != NULL && strcmp(found, line) == 0)
		{
			char* str = (char*) malloc((strlen(line+5) +1) * sizeof(char));
			strcpy(str, line + 5);
			deps[count++] = str;
			//printf("Adding...%s\n", str);
		}
		line = strtok(NULL, "\n");
	}
	//printf("------------\n");
	/*for (i=0; i<length; i++)
	{
		printf("%c", buffer[i]);
	}
	deps = (char**)malloc(sizeof(char*) * 1000);
	line = fgets(line, 256, file);
	if (line == NULL)
	{
		printf("NUll");
	}
	else
	{
		printf("sdf");
	}
	do
	{
		printf("..");
		line = strtok(line, "\n");
		if (strcmp(strstr(line, "#DEP:"), line))
		{
			char* str = (char*) malloc((strlen(line) - 4) * sizeof(char));
			strcpy(str, line + 5);
			deps[count++] = str;
		}
		line = fgets(line, 256, file);
		printf(line);
	}while(line != NULL && strlen(line) != 0);
	printf("***");*/
	return deps;
	//return NULL;
}

void parseDependencies(char* package)
{
	//printf("Finding processed status... %s\n", package);
	//printf("Processed : %d\n", isProcessed(package));
	if (!isProcessed(package) && strlen(package) != 0)
	{
		//printf("Finding deps for [%s]\n", package);
		listAsProcessed(package);
		//printf("listed as processed\n");
		int i = 0;
		FILE* file = readScript(package);
		//printf("Read\n");
		char** deps = findDependencies(file);
		//printf("XXX");
		char* dep = deps[0];
		int x = 0;
		while(dep != NULL)
		{
			//printf(">>%s\n", dep);
			x++;
			dep = deps[x];
		}
		//printf("Found\n");
		//printf("%d\n", deps[i]);
		if (deps[i] != NULL)
		{
			while(deps[i] != NULL)
			{
				parseDependencies(deps[i]);
				i++;
			}
		}
		/*else
		{
			printf("No deps\n");
			printf("Package has to be added %s\n", package);
		}*/
		//printf("XXXXXXX");
		//exit(0);
		//
		listAsDependency(package);
		//exit(0);
		//printf("Listed as dep");
	}
}

void parseDependenciesMultiple(char** packages)
{
	int i=0;
	while(packages[i] != NULL)
	{
		//printf("Parsing Dependencies for %s\n", packages[i]);
		parseDependencies(packages[i]);
		i++;
	}
}

int installSingle(char* package)
{
	FILE* in;
	char* buffer = (char*) malloc(sizeof(char) * 129);
	char* executable = (char*) malloc(sizeof(char) * 512);
	strcpy(executable, "");
	strcat(executable, SCRIPTS_DIR);
	strcat(executable, package);
	strcat(executable, ".sh");
	printf("\nExecuting %s ...\n", executable);
	in = popen(executable, "r");
	while(fread(buffer, 128, 1, in) != 0)
	{
		buffer[128] = '\0';
		printf("%s", buffer);
	}
	if (pclose(in) != 0)
	{
		printf("Error occured in installation of %s. Aborting...", executable);
		exit(1);
	}
}

int doInstall(int argc, char** packages)
{
	int i = 0;
	int notInstalledCount = 0;
	char response;
	printf("Installing...\n");
	printf("Discovering dependencies...\n\n");
	parseDependenciesMultiple(packages);
	while(dependencies[i] != NULL)
	{
		if (!isInstalled(dependencies[i]))
		{
			notInstalledCount++;
		}
		else
		{
			printf("%s is already installed. Skipping...\n", dependencies[i]);
		}
		i++;
	}
	if (!force && notInstalledCount == 0)
	{
		printf("\nNothing to be installed. Bye.\n");
		exit(0);
	}
	i = 0;
	printf("\nThe following packages would be installed.\n\n");
	while(dependencies[i] != NULL)
	{
		if (!force && isInstalled(dependencies[i]))
		{
			i++;
			continue;
		}
		printf("%s ", dependencies[i]);
		i++;
	}
	printf("\n\n");
	printf("Are you sure? (y/n)\n");
	i = 0;
	scanf("%c", &response);
	if (response == 'y' || response == 'Y')
	{
		printf("Installing...\n\n");
		while(dependencies[i] != NULL)
		{
			if (!force && isInstalled(dependencies[i]))
			{
				i++;
				continue;
			}
			installSingle(dependencies[i]);
			i++;
		}
	}
	else
	{
		printf("Bye");
	}
	printf("\n\n");
}

int doForceInstall(int argc, char** packages)
{
	int i;
	force = 1;
	doInstall(argc, packages);
}

void doCleanup()
{
	FILE* in = popen("sudo rm -rf /var/cache/alps/sources/*", "r");
	char *buffer = (char*)malloc(512);
	int response;
	printf("Cleaning up. Please wait...\n");
	while(fgets(buffer, 512, in))
	{
		printf(buffer);
	}
	response = pclose(in);
	if (response != 0)
	{
		printf("Some error occured while cleaning up. Aborting.\n\n");
		exit(1);
	}
	else
	{
		printf("Cleaned up successfully.\n\n");
	}
}

void doUpdate()
{
	printf("Updating...\n");
	FILE* in = popen("cd /var/cache/alps/scripts/ && sudo rm -rf * && sudo wget aryalinux.org/packages/2015/scripts.tar.gz && sudo tar xf scripts.tar.gz && sudo chmod 755 *.sh", "r");
	char *buffer = (char*)malloc(512);
	int response;
	printf("Updating scripts. Please wait...\n");
	while(fgets(buffer, 512, in))
	{
		printf(buffer);
	}
	response = pclose(in);
	if (response != 0)
	{
		printf("Some error occured while updating scripts. Aborting.\n\n");
		exit(1);
	}
	else
	{
		printf("Scripts updated successfully.\n\n");
	}
}

int main(int argc, char** argv)
{
	init();
	if (strcmp(argv[1], "install") == 0)
	{
		doInstall(argc - 2, argv + 2);
		exit(0);
	}
	else if (strcmp(argv[1], "forceinstall") == 0)
	{
		doForceInstall(argc - 2, argv + 2);
		exit(0);
	}
	else if (strcmp(argv[1], "cleanup") == 0)
	{
		doCleanup();
	}
	else if (strcmp(argv[1], "update") == 0)
	{
		doUpdate();
	}
	else
	{
		printf("Unknown command: \"%s\". Doing Nothing.\n", argv[1]);
	}
}
