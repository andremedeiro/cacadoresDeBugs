module cacadoresDeBugs

sig Empresa {
	clientes: some Cliente,
	times: some TimeCadadorDeBug
}

-- Definição de coisas que Envolvem Cliente

sig Cliente {
	projetos: some Projeto
}

sig Projeto {
	repositorio: one Repositorio
}

sig ProjetoEmAndamento extends Projeto {}

sig ProjetoComBug in ProjetoEmAndamento {}

sig Repositorio {
	subpastas: some SubPasta
}

sig SubPasta {
	codigo: one Codigo
}

sig Codigo {
	bugs: set Bug
}

-- Definição de Coisas que Envolvem Bug

sig Bug {
	relatorio: one Relatorio,
	gravidade: Int
}{
	gravidade > 0
	gravidade <= 3
}

sig TimeCadadorDeBug {
	verificando: one ProjetoComBug,
	executa: one RodadaDeTeste
}

sig RodadaDeTeste {
	verifica: one Codigo
}

sig Relatorio {}

-- Fatos

fact Fatos {

	one Empresa

	-- Fatos com relação a Projetos
	all c: Cliente | one clientes.c 			-- Todo Cliente só está em uma empresa
	all proj: Projeto | one projetos.proj		-- Todo Projeto só está em um Cliente
	all rep: Repositorio | one repositorio.rep	-- Todo Repositório só está em um Projeto
	all subP: SubPasta | one subpastas.subP		-- Todo SubPasta só está em um Repositorio
	all cod: Codigo | one codigo.cod			-- Todo Codigo só está em uma SubPasta
	all rep: Repositorio | #rep.subpastas >= 1	-- Todo Tem 1 ou mais SubPastas
	all projBug: ProjetoComBug | #projBug.repositorio.subpastas.codigo.bugs > 0	-- Todo Projeto Com Bug um número de bugs maior que 0
	all projAnda: ProjetoEmAndamento - ProjetoComBug | #projAnda.repositorio.subpastas.codigo.bugs = 0	-- Todo ProjetoEmAndamento que não for ProjetoComBug tem Um Número de Bug = 0
	no proj: (Projeto - ProjetoComBug) | #proj.repositorio.subpastas.codigo.bugs > 0 -- Não Existe Nenhum Projeto com Bugs Maior que 0 que não seja um ProjetoComBug

	-- Fatos com relação a Bugs
	all bug: Bug | one bugs.bug		-- Todo Bug só está em Código
	all time: TimeCadadorDeBug | one times.time -- Todo TimeCacadorDeBug só está em uma empresa
	all rela: Relatorio | one relatorio.rela -- Todo Relatorio só está em um Bug
	all projBug: ProjetoComBug | one verificando.projBug -- Todo ProjetoComBug só é verificado por um TimeCacadorDeBug
	all rodada: RodadaDeTeste | one executa.rodada -- Todo RodadaDeTeste só é executada por um Time
	all cod: Codigo | one verifica.cod -- Todo Codigo só é verifiado por uma RodadaDeTeste
	all time: TimeCadadorDeBug | #time.verificando.repositorio.subpastas.codigo.bugs > 0 -- Todo TimeCacadorDeBug só verifica codigo com Bugs > 0

	#TimeCadadorDeBug = #ProjetoComBug -- O Número de TimesCacadoresDeBug é igual ao número de Projetos Com Bug

}

-- Execute

pred show() {}
run show for 5


-- Identificar e corrigir bugs é uma tarefa essencial no desenvolvimento de bons programas.

-- Em uma empresa de software, cada cliente pode ter um ou mais projetos em andamento.

-- Cada projeto é organizado em um repositório, a qual contém subpastas com as diferentes versões do código do referido projeto.

-- A empresa irá atribuir um time de caçadores de bugs para vasculhar os projetos em andamento que possuem bugs, sempre na versão mais recente do projeto.

-- Cada rodada de testes pode gerar bugs, e para cada bug identificado, há um relatório descrevendo o bug e a gravidade (1 a 3, sendo 3 muito grave).

-- Em um dado momento, um conjunto de bugs pode já ter sido corrigidos, outro conjunto está em andamento, e outros ainda não foram considerados.

