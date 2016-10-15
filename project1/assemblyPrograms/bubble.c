void main()
{
	int* list; //R0  contains data already
	int temp, count, iter; //T0, T1, T2
	for(;count<99;count++)
	{
		temp = count;
		for(iter = count+1;iter<100;iter++)
		{
			if(list[temp] < list[iter])
			{
				temp = iter;
			}
		}
		iter = list[count];
		list[count] = list[temp];
		list[temp] = iter;
	}
}

