using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Reflection;
using ClosedXML.Excel;

namespace Mobile.Core.Util
{
    /// <summary>
    /// Excelに関するユーティリティクラスです。
    /// </summary>
    public class ExcelUtil
    {
        /// <summary>
        /// 現在のパスが「CoreTests/Bin/Debug」配下になっているのでCoreTests配下から参照できるようにする
        /// 呼び出し元のクラス名を取得し、テストクラスと同じフォルダに存在するexcelファイルを読み込めるように加工して返す
        /// </summary>
        private static string GetPath(string path)
        {
            // 「呼び出し元クラス」→「CreateEntity」→「GetPath」なのでStackFrameに2を指定しています。
            // 呼び出し元が変わったりする場合はうまく作り直す必要があるため注意してください。
            var callerFrame = new StackFrame(2);
            var className = callerFrame.GetMethod().ReflectedType?.FullName;
            var name = callerFrame.GetMethod().ReflectedType?.Name;
            if (className == null || name == null)
                throw new ArgumentException("クラス名が取得できません");

            return $"../../{className.Replace("Rogue.Mobile.CoreTests.", "").Replace(name, "").Replace(".", "/")}{path}";
        }

        /// <summary>
        /// 指定したExcelファイルをオブジェクトに変換して取得します。
        /// Excelのシート名：エンティティ名
        /// Excelの1行目：DBの列名に対応するプロパティ名
        /// 
        /// 1行目、1列目は使用しません。（メモとかに使ってください）
        /// ex) var entityList = ExcelUtil.CreateEntity<HogeMaster>("test.xlsx");
        /// 
        /// </summary>
        /// <typeparam name="T">取得したいオブジェクト</typeparam>
        /// <param name="path">取得したいオブジェクトが入っているExcelファイルのパス</param>
        /// <param name="sheetName">シート名</param>
        public static IEnumerable<T> CreateEntity<T>(string path, string sheetName)
        {
            // クラスのインスタンスを生成してプロパティをすべて取得
            var type = typeof(T);
            var properties =
                typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance | BindingFlags.NonPublic);

            var file = GetPath(path);
            using (var workbook = new XLWorkbook(file))
            {
                var workSheet = workbook.Worksheets.Worksheet(sheetName);

                const int startRow = 2;
                const int startColumn = 2;

                var list = new List<T>();
                var row = startRow;

                while (true)
                {
                    var col = startColumn;

                    var obj = Activator.CreateInstance(type);
                    foreach (var property in properties)
                    {

                        SetProperty(obj, property, workSheet.Cell(row, col).Value);
                        col++;
                    }

                    list.Add((T) obj);
                    row++;
                    if (string.IsNullOrEmpty(workSheet.Cell(row, startColumn).Value?.ToString()))
                    {
                        break;
                    }
                }
                return list;
            }
        }
        
        /// <summary>
        /// 指定したオブジェクトのプロパティに値をセットする
        /// </summary>
        /// <param name="obj">取得したいオブジェクトのインスタンス</param>
        /// <param name="propertyInfo">セットしたいプロパティのpropertyInfo</param>
        /// <param name="data">セットする値</param>
        private static void SetProperty(object obj, PropertyInfo propertyInfo, object data)
        {
            if (data.ToString() == "")
                return;

            // 型ごとにキャストしてプロパティを初期化
            // 必要に応じて追加してください
            if (propertyInfo.PropertyType == typeof(int))
            {
                propertyInfo.SetValue(obj, int.Parse(data.ToString()), null);
            }
            else if (propertyInfo.PropertyType == typeof(short))
            {
                propertyInfo.SetValue(obj, short.Parse(data.ToString()), null);
            }
            else if (propertyInfo.PropertyType == typeof(long))
            {
                propertyInfo.SetValue(obj, long.Parse(data.ToString()), null);
            }
            else if (propertyInfo.PropertyType == typeof(double))
            {
                propertyInfo.SetValue(obj, double.Parse(data.ToString()), null);
            }
            else if (propertyInfo.PropertyType == typeof(bool))
            {
                var str = data.ToString();
                if (str == "0")
                    str = "false";
                else if (str == "1")
                    str = "true";
                
                propertyInfo.SetValue(obj, bool.Parse(str), null);
            }
            else if (propertyInfo.PropertyType == typeof(DateTime))
            {
                var str = data.ToString();
                if (str != "")
                    propertyInfo.SetValue(obj, DateTime.Parse(str), null);
            }
            else
            {
                var str = data.ToString();
                if (str.ToLower() == "null")
                {
                    str = null;
                }

                if (propertyInfo.PropertyType == typeof(string))
                {
                    propertyInfo.SetValue(obj, str, null);
                }
                else
                {
                    propertyInfo.SetValue(obj, data, null);
                }
            }
        }
    }
}
