import 'package:flutter/material.dart';

import '../../shared/widgets/top_toast.dart';
import '../create/create_with_ai_screen.dart';
import '../create/creation_mode.dart';
import 'canva_connect_dialog.dart';
import 'canva_connection.dart';
import 'canva_status_dialog.dart';

/// Makes sure Canva is linked (status dialog, then authorization dialog) and
/// returns whether it is ready to use.
Future<bool> ensureCanvaConnected(
  BuildContext context,
  CanvaConnection connection,
) async {
  if (connection.connected) return true;

  final status = await showDialog<CanvaStatusResult>(
    context: context,
    builder: (_) => CanvaStatusDialog(connection: connection),
  );
  if (status == CanvaStatusResult.connected) return true;
  if (status != CanvaStatusResult.connect || !context.mounted) return false;

  final authorized = await showDialog<bool>(
    context: context,
    builder: (_) => CanvaConnectDialog(connection: connection),
  );
  if (authorized != true || !context.mounted) return false;

  showTopToast(context, message: 'Canva berhasil terhubung!');
  return true;
}

/// Opens the Canva creation screen, linking the account first when needed.
Future<void> openCanva(BuildContext context, CanvaConnection connection) async {
  if (!await ensureCanvaConnected(context, connection)) return;
  if (!context.mounted) return;
  await Navigator.of(context).push(
    MaterialPageRoute<void>(
      builder: (_) => const CreateWithAiScreen(mode: CreationMode.canva),
    ),
  );
}
