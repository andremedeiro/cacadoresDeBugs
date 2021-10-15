module cacadoresDeBugs

-- Definição de coisas que Envolvem Cliente

sig Cliente {
	-- Tem 1 ou mais Projetos
	projetos: some Projeto
}

sig Projeto {
	-- Tem 1 Repositório
	repositorio: one Repositorio
}

sig ProjetoEmAndamento extends Projeto {}

sig Repositorio {
	-- Tem 1 ou mais SubPastas
	subpastas: some SubPasta
}

sig SubPasta {
	-- Tem 1 Código
	codigo: one Codigo
}

sig Codigo {
	-- Tem 1 ou mais Bugs
	bugs: set Bug
}

-- Definição de Coisas que Envolvem Bug

sig Bug {
	relatorio: one Relatorio
}

sig Gravidade_1 in Bug {}
sig Gravidade_2 in Bug {}
sig Gravidade_3 in Bug {}

sig TimeCadadorDeBug {
	verificando: set ProjetoEmAndamento
	-- Veifica 1 ou mais Projetos em Andamento
}

-- sig RodadaTeste {
	-- Tem 1 ou mais Bugs
	-- Para cada bug tem um relatório
-- }

sig Relatorio {
	-- Tem 1 Descrição do Bug
	-- Tem a Gravidade do Bug
}

-- Fatos

fact Fatos {

	-- Fatos mais gerais
	some Cliente
	one TimeCadadorDeBug -- DEPOIS MUDAR PARA SOME

	-- Fatos com relação a Projetos
	all proj: Projeto | one projetos.proj
	all rep: Repositorio | one repositorio.rep
	all subP: SubPasta | one subpastas.subP
	all cod: Codigo | one codigo.cod
	all rep: Repositorio | #rep.subpastas >= 1
	all projAnda: ProjetoEmAndamento | #projAnda.repositorio.subpastas.codigo.bugs >= 0
	no proj: (Projeto - ProjetoEmAndamento) | #proj.repositorio.subpastas.codigo.bugs > 0
		
	-- Fatos com relação a Bugs
	all bug: Bug | one bugs.bug
	all rela: Relatorio | one relatorio.rela
	all projAnda: ProjetoEmAndamento | one verificando.projAnda 
	
}


-- Execute

pred show() {}
run show for 5


-- Identificar e corrigir bugs é uma tarefa essencial no desenvolvimento de bons programas. Em uma empresa de software, cada cliente pode ter um ou mais projetos em andamento. Cada projeto é organizado em um repositório, a qual contém subpastas com as diferentes versões do código do referido projeto. A empresa irá atribuir um time de caçadores de bugs para vasculhar os projetos em andamento que possuem bugs, sempre na versão mais recente do projeto. Cada rodada de testes pode gerar bugs, e para cada bug identificado, há um relatório descrevendo o bug e a gravidade (1 a 3, sendo 3 muito grave). Em um dado momento, um conjunto de bugs pode já ter sido corrigidos, outro conjunto está em andamento, e outros ainda não foram considerados.


-- 1 Cliente = 1 ou + Projeto = 1 Repositorio = 1 ou + subpasta = 1 codigo

-- 1 Time = 1 ou + ProjetoEmAndamentoComBug = > subpasta = 1 ou + RodadaTeste = 1 ou + bug = 1 Relatorio [Bug e Gravidade (1 a 3)] 