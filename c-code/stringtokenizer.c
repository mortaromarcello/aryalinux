#include <string.h>
#include <malloc.h>
#include <stdlib.h>
struct token
{
	char* str;
	struct token* next;
};

struct token* tokenize(char* str, char delim)
{
	char* start = NULL;
	char* end = NULL;
	char* tempStr = NULL;
	char* i = NULL;
	struct token* first = NULL;
	struct token* latest = NULL;
	struct token* temp;
	int count = 0;
	int len = 0;

	int x = 0;

	start = str;
	end = str;

	for(; *start != '\0'; end++)
	{
		// printf("start, end : %c, %c\n", *start, *end);
		if ((*end) == delim || (*end) == '\0')
		{
			// printf("end has delimiter.. creating a new token: %c\n", *end);
			len = (int)(end - start);
			// printf("len : %d\n", len);
			if (len != 0)
			{
				tempStr = (char*) malloc(sizeof(char) * (len + 1));
				for (i = start; i < start + len; i++)
				{
					// printf("%d\n", (i - start));
					tempStr[(int)(i - start)] = *i;
				}
				// printf("Extracted : %s\n", tempStr);
				if (count == 0)
				{
					first = (struct token*) malloc(sizeof(struct token) * 1);
					first->str = tempStr;
					first->next = NULL;
					latest = first;
					count++;
				}
				else
				{
					temp = (struct token*) malloc(sizeof(struct token) * 1);
					temp->str = tempStr;
					temp->next = NULL;
					latest->next = temp;
					latest = temp;
					count++;
				}
			}
			if (*(end) == '\0') break;
			if (*(end + 1) == '\0')
			{
				break;
			}
			else
			{
				start = end + 1;
			}
		}
		x++;
	}
	return first;
}
