func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) 
    {

    let now: TimeInterval = Date().timeIntervalSince1970
    if (now - lastClick < 0.3) && (lastIndexPath?.row == indexPath.row )
    {
        print("Double Tap!")
    }
    lastClick = now
    lastIndexPath = indexPath
    }
