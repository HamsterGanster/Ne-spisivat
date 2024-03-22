// Нужно браузерное расширение "User JavaScript and CSS"

// В нём ставите ссылку таблицу с результатами ваших посылок: 
// https://fresh.nsuts.ru/

// Если шарите за Java-script можете своё форматирование добавить
// Хотя цвета сможете поменять и без его знания, думаю

// ИНОГДА ПОМОГАЕТ ПЕРЕЗАГРУЗКА СТРАНИЦЫ

// Вставляете этот код в поле для JS, Ctrl+S (сохранить):

// how often need update ASSEPTED and other fun text
let how_often = 100; // in ms, milliseconds

// light in ranking
let yourColor = '#A5ECFE'; // BackGroundColor — color in ranking
// Dealy before "lighting in ranking"/"deleting a table with attempts" milliseconds.
// If there is no lighting, try to increase the time
let yourDelay = 200; 

let yourTop = 0;

let yourName = 'Мартынов from t.me/baguette_boys'; // точное имя из рейтинга
let autoSearch = 1; // автопоиск имени на странице
let getNameDelay = 500; // задержка в мс перед автоматическим поиском имени

window.onload = function () {  
	if (autoSearch == 1)
    setTimeout(function() {}, 10);(function() {
      // There is only 1 block with the "dropdown" class on the site
      // And it has your name
      yourName = document.getElementsByClassName('dropdown')[0].childNodes[0].textContent;
    }, getNameDelay); 
  }

// your replace text:
testing               = '🐝 Так, ну, подождите...';
accepted              = '🏆 ASSEPTED';
compileError          = '🚧 Compile Error'; // обычное
deadlock              = '🥶 Deadlock - Timeout'; // обычное
judgementFailed       = '🤢 Judgement Failed'; // обычное
juryError             = '🤮 Jury Error'; // обычное
compiled              = '👍 Compiled (и че? 😐)';
memoryLimit           = '🤯 Отдай память!';
noOutputFile          = '🔍 Файл на выход?';
presentationError     = '🚽 Ошибка в презентации';
runTimeError          = '🔥 Алло, пожарные?';
securityViolation     = '💀 Security Violation'; // обычное
timeLimit             = '⌛️ Не тормози - сникерсни';
wrongAnswer           = '                  🗿 Bruh                    '.bold();
staticAnalysisFailed  = '✨ Static Analysis Failed'; // обычное
dynamicAnalysisFailed = '🔧 Dynamic Analysis Failed'; // обычное
skipped         = '👀 Skipped'; // обычное



// function from Internet for searching text in HTML
HTMLElement.prototype.getNodesByText = function (text) {
  const expr = `.//*[text()[contains(
    translate(.,
      'ABCDEFGHIJKLMNOPQRSTUVWXYZАБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯ',
      'abcdefghijklmnopqrstuvwxyzабвгдеёжзийклмнопрстуфхцчшщъыьэюя'
    ),
    '${text.toLowerCase()}'
  )]]`;    /* коммент-костыль */
  const nodeSet = document.evaluate(expr, this, null,
    XPathResult.ORDERED_NODE_SNAPSHOT_TYPE,
  null);
  return Array.from({ length: nodeSet.snapshotLength },
    (v, i) => nodeSet.snapshotItem(i)
  );
};


// function that light your name in ranking 
setInterval(function() {
	document.body.getNodesByText('В туре включено ограничение на количество отправленных решений по задачам.').forEach(
		el => {
			// You can insert more parameters, for example:
			el.parentNode.removeChild(el);
		}
	);
}, yourDelay); 





// function that light your name in ranking 
setInterval(function() {
	document.body.getNodesByText(yourName).forEach(
		el => {
			// el — очередной HTML blocks with yourName (forEach перебирает все)
			// .parent — родительский блок
			// .getEl...TagName — возвращает из родителей только <td> блоки
			var htmlCollection = el.parentNode.getElementsByTagName('td');
			
			// if <td> number greater then 0 htmlColl have line with yourName from ranking
			if (htmlCollection.length > 0) { 
				// get your place in ranking:
				yourTop = htmlCollection[0].textContent; 
				
				// coloring the line:
				el.parentNode.parentNode.getElementsByTagName('tr')[yourTop-1].style.backgroundColor = yourColor;
			} // end if
			
		}   // end el
	);    // end ForEach
}, yourDelay); // end setInterval



// function that replace text to fun
setInterval(function () { 
	// document.body.getNodesByText('YOUR TEXT').forEach(
	// 	el => {
	// 		// просто заменить текст. Можно: "<b> text </b>", но на html это не повлияет и выведет <b> как 3 символа
	// 		el.textContent = 'NEW TEXT';
			
	// 		// если хочешь не просто текст, а изменить html.
	// 		// Может выйт: text, но жирным шрифтом
	// 		el.innerHTML   = 'NEW TEXT'.bold(); 
			
	// 		// You can insert more parameters, for example:
	// 		//el.style.backgroundColor = '#7f7';
			
	// 		// You can get parentNode
	// 		//el.parentNode.style.backgroundColor = '#7f7';
	// 	}
	// );
	
	
	// document.body.getNodesByText('🐝 Testing...').forEach(
 //       el => {
 //           el.textContent = Testing;
 //       }
 //   );
	
	document.body.getNodesByText('🏆 ACCEPTED').forEach(
        el => {
            el.textContent = '🏆 ASSEPTED';
            el.style.backgroundColor = '#0f02';
            el.style.textAlign = 'center';
        }
    ); // end replace ACCEPTED

    document.body.getNodesByText('🚧 Compile Error').forEach(
        el => {
            el.textContent = compileError;
        }
    ); // end replace Compile Error

    document.body.getNodesByText('🥶 Deadlock - Timeout').forEach(
        el => {
            el.textContent = deadlock;
        }
    ); // end replace DeadLock

    document.body.getNodesByText('🤢 Judgement Failed').forEach(
        el => {
            el.textContent = judgementFailed;
        }
    ); // end replace JudgementFailed

    document.body.getNodesByText('🤮 Jury Error').forEach(
        el => {
            el.textContent = juryError;
        }
    ); // end replace JuryError

    document.body.getNodesByText('👍 Compiled').forEach(
        el => {
            el.textContent = compiled;
        }
    ); // end replace Compiled

    document.body.getNodesByText('🤯 Memory Limit Exceeded').forEach(
        el => {
            el.textContent = memoryLimit;
        }
    ); // end replace MemoryLimit

    document.body.getNodesByText('🔍 No Output File').forEach(
        el => {
            el.textContent = noOutputFile;
        }
    ); // end replace NoOutputFile

    document.body.getNodesByText('🚽 Presentation Error').forEach(
        el => {
            el.textContent = presentationError;
        }
    ); // end replace PresentationError

    document.body.getNodesByText('🔥 Run-Time Error').forEach(
        el => {
            el.textContent = runTimeError;
        }
    ); // end replace RunTimeError

    document.body.getNodesByText('💀 Security Violation').forEach(
        el => {
            el.textContent = securityViolation;
        }
    ); // end replace SecurityViolation

    document.body.getNodesByText('⌛ Time Limit Exceeded').forEach(
        el => {
            el.textContent = timeLimit;
        }
    ); // end replace TimeLimit

    document.body.getNodesByText('🗿 Wrong Answer').forEach(
        el => {
            el.innerHTML = wrongAnswer;
            el.style.backgroundColor = '#f0f3';
            el.style.color = '#f00f'; // red
            el.style.width = 75;
        }
    ); // end replace WrongAnswer

    document.body.getNodesByText('✨ Static Analysis Failed').forEach(
        el => {
            el.textContent = staticAnalysisFailed
        }
    ); // end replace StaticAnalysisFailed

    document.body.getNodesByText('🔧 Dynamic Analysis Failed').forEach(
        el => {
            el.textContent = dynamicAnalysisFailed;
        }
    ); // end replace DynamicAnalysisFailed

    document.body.getNodesByText('👀 Skipped').forEach(
        el => {
            el.textContent = skipped;
        }
    ); // end replace Skipped

	
}, how_often); // end setInterval() for replace verdicts
