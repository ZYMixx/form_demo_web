import 'package:mysql1/mysql1.dart';

import 'db_entity_form_abstr.dart';

class KonstrForm extends BdFormEntityAbstr {
  int id;
  String tip;
  int height;
  int line_jumper; // линейные связи
  int univ_jamper;
  int line_pipe;
  int pipe_edge;
  double job_dopOp;
  String comment;

  //ConstantsForm constantsForm;

  static const String tableName = "konstr";

  KonstrForm(ResultRow row)
      : id = row.fields["id"],
        tip = row.fields["tip"],
        height = row.fields["height"],
        line_jumper = row.fields["line_jumper"],
        univ_jamper = row.fields["univ_jamper"],
        line_pipe = row.fields["line_pipe"],
        pipe_edge = row.fields["pipe_edge"],
        job_dopOp = row.fields["job_dopOp"],
        comment = row.fields["comment"] {
    tip = tip.trim();
  }

  @override
  String toString() {
    return 'KonstrForm{tip: $tip, height: $height}';
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'tip': tip,
      'height': height,
      'line_jumper': line_jumper,
      'univ_jamper': univ_jamper,
      'line_pipe': line_pipe,
      'pipe_edge': pipe_edge,
      'job_dopOp': job_dopOp,
      'comment': comment,
    };
  }
}

// +-------------+------------------+------+-----+---------+----------------+
// | Field       | Type             | Null | Key | Default | Extra          |
// +-------------+------------------+------+-----+---------+----------------+
// | id          | int(11) unsigned | NO   | PRI | NULL    | auto_increment |
// | tip         | varchar(20)      | NO   |     | NULL    |                |
// | height      | int(10) unsigned | NO   |     | NULL    |                |
// | line_jumper | int(11)          | NO   |     | NULL    |                |
// | univ_jamper | int(11)          | NO   |     | NULL    |                |
// | line_pipe   | int(11)          | NO   |     | NULL    |                |
// | pipe_edge   | int(11)          | NO   |     | NULL    |                |
// | job_dopOp   | double           | NO   |     | 0       |                |
// | comment     | varchar(255)     | NO   |     |         |                |
// +-------------+------------------+------+-----+---------+----------------+
