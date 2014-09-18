:- set_prolog_flag(toplevel_print_options, [max_depth(100)]).
:- use_module(library(lists)).

% -----------------------------------------------------------------------------------%
%                                       QUESTION 1                                   %
% -----------------------------------------------------------------------------------%

% Replaces every instance of the word bear with the word double%

decode_message(bear, double, [],[]).
decode_message(bear, double, [bear|T1], [double|T2]):- decode_message(bear, double, T1, T2).
decode_message(bear, double, [H|T1], [H|T2]):- bear\=H,
                                               decode_message(bear, double, T1, T2).

% Replaces every instance of the word cub with the word agent%

decode_message(cub, agent, [],[]).
decode_message(cub, agent, [cub|T1], [agent|T2]):- decode_message(cub, agent, T1, T2).
decode_message(cub, agent, [H|T1], [H|T2]):- cub\=H,
                                             decode_message(cub, agent, T1, T2).

% First decodes the message by replaceing the word bear with double and stores the decoded message  %
% in a temporary list. The temp list is then decoded replacing cub with agent and is finally stored %
% in the Decoded_Message list.									    %

decode(Message, Decoded_Message):- decode_message(bear, double, Message, Temp_List),
                                   decode_message(cub, agent, Temp_List, Decoded_Message).


% -----------------------------------------------------------------------------------%
%                                       QUESTION 2                                   %
% -----------------------------------------------------------------------------------%

% cubs/3 searches a list for the word 'cub' preceeded by the words  		%
% 'X,is,a,bear' and stores X (spy's name) in a seperate list. This is done 	%
% before the message is decoded.						% 


cubs([],_,[]).

cubs([Spy,is,a,bear,Cub|X], Cub, [Spy|Spies]) :- cubs(X, Cub, Spies).

cubs([_|X], Cub, Spies) :- cubs(X, Cub, Spies).

list_spies(List, Names) :- cubs(List, cub, Names).

agents(Message, Decoded_Message, ListofAgents):- list_spies(Message, Temp_ListofAgents),
 						 sort(Temp_ListofAgents, ListofAgents),
					         decode(Message, Decoded_Message).


% -----------------------------------------------------------------------------------%
%                                       QUESTION 3                                   %
% -----------------------------------------------------------------------------------%

% count_word/3 compares Word to the head of the list. If it matches, Count is increased %
% by one. The head is discarded and the process is repeated on the tail of the list     %

count_word(_, [], 0).

count_word(Word, [Word|Tail], Count):- count_word(Word, Tail, X), 
       				       Count is X + 1.

count_word(Word, [Z|Tail], Count):- Word \= Z, 
    				    count_word(Word, Tail, Count).



% -----------------------------------------------------------------------------------%
%                                       QUESTION 4                                   %
% -----------------------------------------------------------------------------------%

% new_count/3 searches through the list Message and counts the number of times Spy_Name	%
% is repeated, storing (Spy_name, Count) in another list. The process is repeated with	%
% the head of the remaining tail Other_Spies.                                           %

new_count(Message, [], []).
new_count(Message, [Spy_Name|Other_Spies], [Repeat_Name|Tail]):- count_word(Spy_Name, Message, Count), 
						       Repeat_Name = (Spy_Name, Count), 
						       new_count(Message, Other_Spies, Tail).

count_ag_names(Message, Ag_name_counts):- agents(Message, Decoded_Message, ListofAgents),
				  	  new_count(Message, ListofAgents, Ag_name_counts).
					  

