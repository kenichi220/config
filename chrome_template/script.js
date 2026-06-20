document.addEventListener('DOMContentLoaded', () => {
    
    const linksGrid = document.getElementById('linksGrid');

    // Carrega os links do LocalStorage. Se não existir, inicia um array vazio.
    let myLinks = JSON.parse(localStorage.getItem('savedLinks')) || [];

    // Função principal que desenha as caixas na tela
    function renderLinks() {
        linksGrid.innerHTML = ''; // Limpa a tela antes de desenhar

        // 1. Desenha as caixas salvas
        myLinks.forEach((link, index) => {
            const box = document.createElement('div');
            box.className = 'link-box';

            // Título clicável
            const title = document.createElement('span');
            title.className = 'link-title';
            title.innerText = link.name;
            title.onclick = () => { window.location.href = link.url; };

            // Botão de deletar
            const deleteBtn = document.createElement('button');
            deleteBtn.className = 'delete-link-btn';
            deleteBtn.innerText = '✕';
            deleteBtn.title = 'Deletar link';
            deleteBtn.onclick = (event) => {
                event.stopPropagation(); // Impede que clicar no X abra o link
                if (confirm(`Tem certeza que deseja deletar "${link.name}"?`)) {
                    myLinks.splice(index, 1); // Remove do array
                    saveAndRender(); // Salva e atualiza a tela
                }
            };

            box.appendChild(title);
            box.appendChild(deleteBtn);
            linksGrid.appendChild(box);
        });

        // 2. Desenha a caixa de "Adicionar" sempre no final
        const addBox = document.createElement('div');
        addBox.className = 'link-box add-box';
        addBox.innerText = '+ Add Link';
        addBox.onclick = () => {
            const name = prompt('Nome do link (ex: GitHub):');
            if (!name) return; // Cancela se deixar vazio
            
            let url = prompt('URL do link (ex: github.com):');
            if (!url) return;

            // Formatação de segurança: adiciona https:// se o usuário esquecer
            if (!url.startsWith('http://') && !url.startsWith('https://')) {
                url = 'https://' + url;
            }

            myLinks.push({ name, url }); // Adiciona ao array
            saveAndRender(); // Salva e atualiza a tela
        };
        
        linksGrid.appendChild(addBox);
    }

    // Função para salvar no navegador e redesenhar
    function saveAndRender() {
        localStorage.setItem('savedLinks', JSON.stringify(myLinks));
        renderLinks();
    }

    // Roda a função a primeira vez que a página carrega
    renderLinks();

    // ==========================================
    // BOTÕES INFERIORES DIREITOS (Mantidos iguais)
    // ==========================================
    document.getElementById('btn-search').addEventListener('click', () => {
        const query = prompt('Pesquisar no Google:');
        if (query) window.location.href = `https://www.google.com/search?q=${encodeURIComponent(query)}`;
    });
    document.getElementById('btn-downloads').addEventListener('click', () => {
        chrome.tabs.create({ url: 'chrome://downloads/' });
    });
    document.getElementById('btn-incognito').addEventListener('click', () => {
        chrome.windows.create({ incognito: true });
    });
    document.getElementById('btn-apps').addEventListener('click', () => {
        chrome.tabs.create({ url: 'chrome://extensions/' });
    });
    document.getElementById('btn-eye').addEventListener('click', () => {
        document.body.classList.toggle('hide-ui');
    });
    document.getElementById('btn-settings').addEventListener('click', () => {
        chrome.tabs.create({ url: 'chrome://settings/' });
    });
});
