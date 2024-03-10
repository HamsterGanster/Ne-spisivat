// Нужно браузерное расширение "User JavaScript and CSS"

// В нём ставите ссылку таблицу с результатами ваших посылок: 
// https://fresh.nsuts.ru/nsuts-new/new_report

// Если шарите за Java-script можете своё форматирование добавить
// Хотя цвета сможете поменять и без его знания, думаю


// Вставляете этот код в поле для JS, Ctrl+S (сохранить):

let how_often = 100; // время в мс, как часто обновлять текст

// функция чисто из Интернета
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


// тут уже сам))
setInterval(function () { 
	document.body.getNodesByText('YOUR TEXT').forEach(
		el => {
			// просто заменить текст. Может выйти: "<b> text </b>"
			el.textContent = 'NEW TEXT';
			
			// если хочешь не просто текст, а изменить html.
			// Может выйт: text, но жирным шрифтом
			el.innerHTML   = 'NEW TEXT'.bold(); 
			
			// You can insert more parameters, for example:
			//el.style.backgroundColor = '#7f7';
		}
	);
	
	// document.body.getNodesByText('🐝 Testing...').forEach(
 //       el => {
 //           el.textContent = '🐝 Так, ну, подождите...';
 //       }
 //   );
	
	document.body.getNodesByText('🏆 ACCEPTED').forEach(
        el => {
            el.textContent = '🏆 ASSEPTED';
            el.style.backgroundColor = '#0f02';
            el.style.textAlign = 'center';
        }
    );

    document.body.getNodesByText('🚧 Compile Error').forEach(
        el => {
            el.textContent = '🚧 Compile Error';
        }
    );

    document.body.getNodesByText('🥶 Deadlock - Timeout').forEach(
        el => {
            el.textContent = '🥶 Deadlock - Timeout';
        }
    );

    document.body.getNodesByText('🤢 Judgement Failed').forEach(
        el => {
            el.textContent = '🤢 Judgement Failed';
        }
    );

    document.body.getNodesByText('🤮 Jury Error').forEach(
        el => {
            el.textContent = '🤮 Jury Error';
        }
    );

    document.body.getNodesByText('👍 Compiled').forEach(
        el => {
            el.textContent = '👍 Compiled (и че? 😐)';
        }
    );

    document.body.getNodesByText('🤯 Memory Limit Exceeded').forEach(
        el => {
            el.textContent = '🤯 Отдай память!';
        }
    );

    document.body.getNodesByText('🔍 No Output File').forEach(
        el => {
            el.textContent = '🔍 Файл на выход?';
        }
    );

    document.body.getNodesByText('🚽 Presentation Error').forEach(
        el => {
            el.textContent = '🚽 Ошибка в презентации';
        }
    );

    document.body.getNodesByText('🔥 Run-Time Error').forEach(
        el => {
            el.textContent = '🔥 Алло, пожарные?';
        }
    );

    document.body.getNodesByText('💀 Security Violation').forEach(
        el => {
            el.textContent = '💀 Security Violation';
        }
    );

    document.body.getNodesByText('⌛ Time Limit Exceeded').forEach(
        el => {
            el.textContent = '⌛️ Не тормози - сникерсни';
        }
    );

    document.body.getNodesByText('🗿 Wrong Answer').forEach(
        el => {
            el.innerHTML = '                  🗿 Bruh                    '.bold();
            el.style.backgroundColor = '#f0f3';
            el.style.color = '#f00f'; // red
            el.style.width = 75;
        }
    );

    document.body.getNodesByText('✨ Static Analysis Failed').forEach(
        el => {
            el.textContent = '✨ Static Analysis Failed';
        }
    );

    document.body.getNodesByText('🔧 Dynamic Analysis Failed').forEach(
        el => {
            el.textContent = '🔧 Dynamic Analysis Failed';
        }
    );

    document.body.getNodesByText('👀 Skipped').forEach(
        el => {
            el.textContent = '👀 Skipped';
        }
    );

	
}, how_often);
