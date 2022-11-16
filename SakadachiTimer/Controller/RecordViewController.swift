//
//  ViewController.swift
//  Sakadatsu
//
//  Created by Masato Sawada on 2022/11/13.
//

import UIKit
import AVFoundation
import RealmSwift

class RecordViewController: UITableViewController {

    var timer = Timer()
    var countRound = 0.0
    var player: AVAudioPlayer?
    var session = AVAudioSession.sharedInstance()
    let realm = try! Realm()
    var recordItem: Results<RecordTemp>? // Results が自動でrealmの結果を返してくれる
    let dateFormatter = DateFormatter()

    override func viewDidLoad() {
        super.viewDidLoad()
        // realm のパス(デバッグ用)
        print(Realm.Configuration.defaultConfiguration.fileURL ?? "filePath error")

        // orientation 検出準備
        NotificationCenter.default.addObserver(
                    self,
                    selector: #selector(RecordViewController.orientationChanged),
                    name: UIDevice.orientationDidChangeNotification,
                    object: nil)
        
        // tableView load
        loadItem()
    }
    
    //MARK: - delete item
    @IBAction func trashItems(_ sender: UIBarButtonItem) {
        deleteItem()
    }
    
    //MARK: - Orientation Detect
    @objc func orientationChanged() {

        let orientation = UIDevice.current.orientation
        let rawvalue = orientation.rawValue // detect orientation state
        
        if rawvalue == 2 {
            var count = 0.0
            timer = Timer.scheduledTimer(withTimeInterval: 0.1, repeats: true) { (Timer) in
                count += 0.1
                // countを演算する。整数になるところで音を鳴らす。
                self.countRound = round(count*10) / 10
                let decimal = self.countRound.truncatingRemainder(dividingBy: 1)
                if decimal == 0.0 {
                    self.playSound(title: "count")
                }
                
                print(self.countRound)
            }
        } else {
            if countRound >= 1 {
                writeInRealm() // 1秒以上は記録
                loadItem()
            }
            self.countRound = 0
            timer.invalidate()
        }

    }
    
    
    //MARK: - Tableview Datasource Methods
    // テーブルに何行のリスト、何個のセルを入れるか
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if recordItem?.count == 0 {
            return 1
        }
        return recordItem?.count ?? 1
    }
    
    // セルの数だけこの関数が呼び出される。indexPathプロパティはUITableViewで用意されている。(delegateメソッド)
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecordTempCell", for: indexPath)
        cell.textLabel?.textColor = .black
        
        if recordItem?.count == 0 {
            cell.textLabel?.text = "逆立ちをしてデータを取得しよう"
            cell.accessoryType = .none
            
        } else {
            if let item = recordItem?[indexPath.row] {
                dateFormatter.dateFormat = "HH時mm分ss秒" // 時間の表記を設定
                let str = dateFormatter.string(from: item.dateCreated!) // 変換
                cell.textLabel?.text = "score: \(item.time)秒  |  time: \(String(describing: str))"
                cell.accessoryType = item.done ? .checkmark : .none // checkmark_ON/OFF
            }
        }
        return cell
    }

    //MARK: - TableView Delegate Methods
    // Cell が選択された時に呼び出される
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        tableView.deselectRow(at: indexPath, animated: true) // 選択された後すぐ解除
        if recordItem?.count == 0 {
            return
        }
        
        if let item = recordItem?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            } catch {
                print("Error toggle item: \(error)")
            }
            print(indexPath)
        }
        tableView.reloadData()

    }
    
    //MARK: - Model Manupulation Methos
    func loadItem() {
        
        recordItem = realm.objects(RecordTemp.self).sorted(byKeyPath: "dateCreated", ascending: false)
        tableView.reloadData()
    }
    
    
//MARK: - Presenter
    
    //MARK: - Player
    func playSound(title: String) {
        if let url = Bundle.main.url(forResource: title, withExtension: "mp3") {
            do {
                player = try AVAudioPlayer(contentsOf: url)
                player?.play()
                try session.setCategory(.playback)
            } catch {
                print("プレイヤーの再生に失敗しました。")
            }
        }
    }
    
    //MARK: - realmに書き込み
    func writeInRealm() {
        do {
            try realm.write {
                let recordTemp = RecordTemp()
                recordTemp.time = countRound
                recordTemp.dateCreated = Date()
                
                realm.add(recordTemp)
            }
        } catch {
            print("error")
        }
    }
    
    //MARK: - チェックした項目をdelete
    func deleteItem() {
        let alert = UIAlertController(title: "チェック項目を削除してよろしいですか？", message: "チェックを入れた項目を全て削除します。", preferredStyle: .alert)
        let OKAction = UIAlertAction(title: "OK", style: .default) { (success) in
            do {
                try self.realm.write {
                    for item in self.recordItem! {
                        if item.done {
                            self.realm.delete(item)
                        }
                    }
                }
                self.loadItem()
            } catch {
                print("raise error")
            }
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .default) { (success) in
            return
        }
        
        if checkmark() {
            // checkmark > 0
            alert.addAction(OKAction)
            alert.addAction(CancelAction)
            present(alert, animated: true)
        } else {
            // checkmark = 0
            let noCheckAlert = UIAlertController(title: "削除する項目にチェックをいれてください。", message: "タップするとチェックが入ります。", preferredStyle: .alert)
            noCheckAlert.addAction(CancelAction)
            present(noCheckAlert, animated: true)
        }
        
    }
    
    //MARK: - item is checked?
    func checkmark() -> Bool {
        for item in self.recordItem! {
            if item.done {
                return true
            }
        }
        return false
    }

}

